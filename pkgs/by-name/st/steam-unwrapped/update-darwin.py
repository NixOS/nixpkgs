#!/usr/bin/env python3

"""Update the Darwin Steam bootstrap package from Valve's public manifest."""

from __future__ import annotations

import io
import pathlib
import re
import shutil
import subprocess  # noqa: S404
import sys
import urllib.error
import urllib.parse
import urllib.request
import zipfile
from typing import NoReturn, cast

MANIFEST_URL = "https://client-update.fastly.steamstatic.com/steam_client_osx"
ARCHIVE_URL_PREFIX = "https://client-update.fastly.steamstatic.com/"
PACKAGE_FILE = pathlib.Path(__file__).with_name("darwin.nix")
VERSION_FILE = "SteamMacBootstrapper.version"
OPEN_BRACE = chr(123)
CLOSE_BRACE = chr(125)
QUOTE = '"'
HEX_SHA256_RE = re.compile(r"^[0-9a-f]{64}$")


class ManifestError(ValueError):
    """Raised when Valve's manifest is syntactically valid but structurally unexpected."""


class UpdateError(RuntimeError):
    """Raised when the updater cannot safely fetch or transform upstream metadata."""


def _raise_manifest_error(message: str) -> NoReturn:
    raise ManifestError(message)


def _raise_update_error(message: str) -> NoReturn:
    raise UpdateError(message)


def _raise_type_error(message: str) -> NoReturn:
    raise TypeError(message)


def _write_stdout(message: str) -> None:
    sys.stdout.write(f"{message}\n")


def _write_stderr(message: str) -> None:
    sys.stderr.write(f"{message}\n")


def _tokenize(text: str) -> list[str]:
    tokens: list[str] = []
    idx = 0
    while idx < len(text):
        char = text[idx]
        if char.isspace():
            idx += 1
            continue
        if char in {OPEN_BRACE, CLOSE_BRACE}:
            tokens.append(char)
            idx += 1
            continue
        if char != QUOTE:
            message = f"Unexpected character {char!r} while parsing manifest"
            _raise_manifest_error(message)
        idx += 1
        start = idx
        while idx < len(text) and text[idx] != QUOTE:
            idx += 1
        if idx >= len(text):
            message = "Unterminated quoted string while parsing manifest"
            _raise_manifest_error(message)
        tokens.append(text[start:idx])
        idx += 1
    return tokens


def _parse_mapping(
    tokens: list[str], start: int = 0, *, top_level: bool = False
) -> tuple[dict[str, object], int]:
    data: dict[str, object] = {}
    idx = start

    while idx < len(tokens):
        token = tokens[idx]
        if token == CLOSE_BRACE:
            if top_level:
                message = "Unexpected closing brace at top level"
                _raise_manifest_error(message)
            return data, idx + 1
        if token == OPEN_BRACE:
            message = f"Unexpected opening brace at token {idx}"
            _raise_manifest_error(message)

        key = token
        idx += 1
        if idx >= len(tokens):
            message = f"Missing value for key {key!r}"
            _raise_manifest_error(message)

        value_token = tokens[idx]
        idx += 1
        if value_token == OPEN_BRACE:
            value, idx = _parse_mapping(tokens, idx, top_level=False)
        elif value_token == CLOSE_BRACE:
            message = f"Unexpected closing brace after key {key!r}"
            _raise_manifest_error(message)
        else:
            value = value_token

        data[key] = value

    if top_level:
        return data, idx

    message = "Unexpected end of manifest while parsing nested mapping"
    _raise_manifest_error(message)


def _parse_manifest(text: str) -> dict[str, object]:
    tokens = _tokenize(text)
    parsed, next_index = _parse_mapping(tokens, top_level=True)
    if next_index != len(tokens):
        message = "Trailing tokens after manifest parse"
        _raise_manifest_error(message)
    return parsed


def _validate_https_url(url: str) -> str:
    parsed = urllib.parse.urlparse(url)
    if parsed.scheme != "https" or not parsed.netloc:
        message = f"Refusing non-HTTPS or malformed URL: {url}"
        _raise_update_error(message)
    return url


def _fetch_bytes(url: str) -> bytes:
    validated_url = _validate_https_url(url)
    with urllib.request.urlopen(validated_url) as response:  # noqa: S310
        return response.read()


def _fetch_text(url: str) -> str:
    return _fetch_bytes(url).decode("utf-8")


def _bootstrap_version_from_archive(archive_bytes: bytes) -> str:
    with zipfile.ZipFile(io.BytesIO(archive_bytes)) as archive:
        try:
            return archive.read(VERSION_FILE).decode("utf-8").strip()
        except KeyError as exc:
            message = f"Archive did not contain {VERSION_FILE!r}"
            raise UpdateError(message) from exc


def _find_nix() -> str:
    nix_path = shutil.which("nix")
    if nix_path is None:
        message = "Could not find `nix` in PATH"
        _raise_update_error(message)
    return nix_path


def _to_sri(hex_hash: str) -> str:
    if HEX_SHA256_RE.fullmatch(hex_hash) is None:
        message = f"Expected a lowercase hexadecimal SHA-256 digest, got {hex_hash!r}"
        _raise_update_error(message)

    completed = subprocess.run(  # noqa: S603
        [
            _find_nix(),
            "hash",
            "convert",
            "--hash-algo",
            "sha256",
            "--from",
            "base16",
            "--to",
            "sri",
            hex_hash,
        ],
        check=True,
        capture_output=True,
        text=True,
    )
    return completed.stdout.strip()


def _replace_once(content: str, pattern: str, replacement: str) -> str:
    updated, count = re.subn(pattern, replacement, content, count=1)
    if count != 1:
        message = f"Expected to replace exactly one occurrence of {pattern!r}"
        _raise_update_error(message)
    return updated


def _require_mapping(value: object, *, name: str) -> dict[str, object]:
    if not isinstance(value, dict):
        message = f"Manifest {name!r} entry is not a mapping"
        _raise_type_error(message)

    if not all(isinstance(key, str) for key in value):
        message = f"Manifest {name!r} entry contains a non-string key"
        _raise_type_error(message)

    return cast("dict[str, object]", value)


def _require_string(value: object, *, name: str) -> str:
    if not isinstance(value, str):
        message = f"Manifest {name!r} entry is not a string"
        _raise_type_error(message)
    return value


def _main() -> int:
    manifest = _parse_manifest(_fetch_text(MANIFEST_URL))
    osx = _require_mapping(manifest.get("osx"), name="osx")
    appdmg = _require_mapping(osx.get("appdmg_osx"), name="appdmg_osx")

    client_version = _require_string(osx.get("version"), name="osx.version")
    src_file = _require_string(appdmg.get("file"), name="appdmg_osx.file")
    src_hash_hex = _require_string(appdmg.get("sha2"), name="appdmg_osx.sha2")

    archive_url = f"{ARCHIVE_URL_PREFIX}{src_file}"
    archive_bytes = _fetch_bytes(archive_url)
    bootstrap_version = _bootstrap_version_from_archive(archive_bytes)
    src_hash = _to_sri(src_hash_hex)

    original = PACKAGE_FILE.read_text(encoding="utf-8")
    updated = _replace_once(
        original,
        r'bootstrapVersion = ".*?";',
        f'bootstrapVersion = "{bootstrap_version}";',
    )
    updated = _replace_once(
        updated,
        r'clientVersion = ".*?";',
        f'clientVersion = "{client_version}";',
    )
    updated = _replace_once(
        updated,
        r'srcFile = ".*?";',
        f'srcFile = "{src_file}";',
    )
    updated = _replace_once(updated, r'hash = ".*?";', f'hash = "{src_hash}";')

    if updated != original:
        PACKAGE_FILE.write_text(updated, encoding="utf-8")
        _write_stdout(
            "Updated steam-unwrapped Darwin package to bootstrap "
            f"{bootstrap_version}, client {client_version}"
        )
    else:
        _write_stdout(
            "steam-unwrapped Darwin package already at bootstrap "
            f"{bootstrap_version}, client {client_version}"
        )

    return 0


if __name__ == "__main__":
    try:
        sys.exit(_main())
    except (
        ManifestError,
        OSError,
        subprocess.CalledProcessError,
        TypeError,
        UpdateError,
        urllib.error.URLError,
        zipfile.BadZipFile,
    ) as exc:
        _write_stderr(f"error: {exc}")
        sys.exit(1)
