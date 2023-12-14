#!/usr/bin/env nix-shell
#! nix-shell -i "python3 -I" -p python3

from contextlib import contextmanager
from pathlib import Path
from typing import Iterable, Optional
from urllib import request

import hashlib, json


def getMetadata(apiKey: str, family: str = "Noto Emoji"):
    '''Fetch the Google Fonts metadata for a given family.

    An API key can be obtained by anyone with a Google account (🚮) from
      `https://developers.google.com/fonts/docs/developer_api#APIKey`
    '''
    from urllib.parse import urlencode

    with request.urlopen(
            "https://www.googleapis.com/webfonts/v1/webfonts?" +
            urlencode({ 'key': apiKey, 'family': family })
    ) as req:
        return json.load(req)

def getUrls(metadata) -> Iterable[str]:
    '''Fetch all files' URLs from Google Fonts' metadata.

    The metadata must obey the API v1 schema, and can be obtained from:
      https://www.googleapis.com/webfonts/v1/webfonts?key=${GOOGLE_FONTS_TOKEN}&family=${FAMILY}
    '''
    return ( url for i in metadata['items'] for _, url in i['files'].items() )


def hashUrl(url: str, *, hash: str = 'sha256'):
    '''Compute the hash of the data from HTTP GETing a given `url`.

    The `hash` must be an algorithm name `hashlib.new` accepts.
    '''
    with request.urlopen(url) as req:
        return hashlib.new(hash, req.read())


def sriEncode(h) -> str:
    '''Encode a hash in the SRI format.

    Takes a `hashlib` object, and produces a string that
    nixpkgs' `fetchurl` accepts as `hash` parameter.
    '''
    from base64 import b64encode
    return f"{h.name}-{b64encode(h.digest()).decode()}"

def validateSRI(sri: Optional[str]) -> Optional[str]:
    '''Decode an SRI hash, return `None` if invalid.

    This is not a full SRI hash parser, hash options aren't supported.
    '''
    from base64 import b64decode

    if sri is None:
        return None

    try:
        hashName, b64 = sri.split('-', 1)

        h = hashlib.new(hashName)
        digest = b64decode(b64, validate=True)
        assert len(digest) == h.digest_size

    except:
        return None
    else:
        return sri


def hashUrls(
    urls: Iterable[str],
    knownHashes: dict[str, str] = {},
) -> dict[str, str]:
    '''Generate a `dict` mapping URLs to SRI-encoded hashes.

    The `knownHashes` optional parameter can be used to avoid
    re-downloading files whose URL have not changed.
    '''
    return {
        url: validateSRI(knownHashes.get(url)) or sriEncode(hashUrl(url))
        for url in urls
    }


@contextmanager
def atomicFileUpdate(target: Path):
    '''Atomically replace the contents of a file.

    Yields an open file to write into; upon exiting the context,
    the file is closed and (atomically) replaces the `target`.

    Guarantees that the `target` was either successfully overwritten
    with new content and no exception was raised, or the temporary
    file was cleaned up.
    '''
    from tempfile import mkstemp
    fd, _p = mkstemp(
        dir = target.parent,
        prefix = target.name,
    )
    tmpPath = Path(_p)

    try:
        with open(fd, 'w') as f:
            yield f

        tmpPath.replace(target)

    except Exception:
        tmpPath.unlink(missing_ok = True)
        raise


if __name__ == "__main__":
    from os import environ
    from urllib.error import HTTPError

    environVar = 'GOOGLE_FONTS_TOKEN'
    currentDir = Path(__file__).parent
    metadataPath = currentDir / 'noto-emoji.json'

    try:
        apiToken = environ[environVar]
        metadata = getMetadata(apiToken)

    except (KeyError, HTTPError) as exn:
        # No API key in the environment, or the query was rejected.
        match exn:
            case KeyError if exn.args[0] == environVar:
                print(f"No '{environVar}' in the environment, "
                       "skipping metadata update")

            case HTTPError if exn.getcode() == 403:
                print("Got HTTP 403 (Forbidden)")
                if apiToken != '':
                    print("Your Google API key appears to be valid "
                          "but does not grant access to the fonts API.")
                    print("Aborting!")
                    raise SystemExit(1)

            case HTTPError if exn.getcode() == 400:
                # Printing the supposed token should be fine, as this is
                #  what the API returns on invalid tokens.
                print(f"Got HTTP 400 (Bad Request), is this really an API token: '{apiToken}' ?")
            case _:
                # Unknown error, let's bubble it up
                raise

        # In that case just use the existing metadata
        with metadataPath.open() as metadataFile:
            metadata = json.load(metadataFile)

        lastModified = metadata["items"][0]["lastModified"];
        print(f"Using metadata from file, last modified {lastModified}")

    else:
        # If metadata was successfully fetched, validate and persist it
        lastModified = metadata["items"][0]["lastModified"];
        print(f"Fetched current metadata, last modified {lastModified}")
        with atomicFileUpdate(metadataPath) as metadataFile:
            json.dump(metadata, metadataFile, indent = 2)
            metadataFile.write("\n")  # Pacify nixpkgs' dumb editor config check

    hashPath = currentDir / 'noto-emoji.hashes.json'
    try:
        with hashPath.open() as hashFile:
            hashes = json.load(hashFile)
    except FileNotFoundError:
        hashes = {}

    with atomicFileUpdate(hashPath) as hashFile:
        json.dump(
            hashUrls(getUrls(metadata), knownHashes = hashes),
            hashFile,
            indent = 2,
        )
        hashFile.write("\n")  # Pacify nixpkgs' dumb editor config check
