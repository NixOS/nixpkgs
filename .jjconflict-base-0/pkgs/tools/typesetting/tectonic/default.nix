/*
  This file provides the `tectonic-unwrapped` package. On the other hand,
  the `tectonic` package is defined in `./wrapper.nix`, by wrapping
  - [`tectonic-unwrapped`](./default.nix) i.e. this package, and
  - [`biber-for-tectonic`](./biber.nix),
    which provides a compatible version of `biber`.
*/

{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
, fontconfig
, harfbuzz
, openssl
, pkg-config
, icu
, fetchpatch2
}:

rustPlatform.buildRustPackage rec {
  pname = "tectonic";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "tectonic-typesetting";
    repo = "tectonic";
    rev = "tectonic@${version}";
    sha256 = "sha256-xZHYiaQ8ASUwu0ieHIXcjRaH06SQoB6OR1y7Ok+FjAs=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/tectonic-typesetting/tectonic/pull/1155
      name = "1155-fix-endless-reruns-when-generating-bbl";
      url = "https://github.com/tectonic-typesetting/tectonic/commit/fbb145cd079497b8c88197276f92cb89685b4d54.patch";
      hash = "sha256-6FW5MFkOWnqzYX8Eg5DfmLaEhVWKYVZwodE4SGXHKV0=";
    })
  ];

  cargoPatches = [
    (fetchpatch2 {
      # cherry-picked from https://github.com/tectonic-typesetting/tectonic/pull/1202
      name = "1202-fix-build-with-rust-1_80";
      url = "https://github.com/tectonic-typesetting/tectonic/commit/6b49ca8db40aaca29cb375ce75add3e575558375.patch";
      hash = "sha256-i1L3XaSuBbsmgOSXIWVqr6EHlHGs8A+6v06kJ3C50sk=";
    })
  ];

  cargoHash = "sha256-Zn+xU6NJOY+jDYrSGsbYGAVqprQ6teEdNvlTNDXuzKs=";

  nativeBuildInputs = [ pkg-config ];

  buildFeatures = [ "external-harfbuzz" ];

  buildInputs = [ icu fontconfig harfbuzz openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (with darwin.apple_sdk.frameworks; [ ApplicationServices Cocoa Foundation ]);

  postInstall = ''
    # Makes it possible to automatically use the V2 CLI API
    ln -s $out/bin/tectonic $out/bin/nextonic
  '' + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace dist/appimage/tectonic.desktop \
      --replace Exec=tectonic Exec=$out/bin/tectonic
    install -D dist/appimage/tectonic.desktop -t $out/share/applications/
    install -D dist/appimage/tectonic.svg -t $out/share/icons/hicolor/scalable/apps/
  '';

  doCheck = true;

  meta = with lib; {
    description = "Modernized, complete, self-contained TeX/LaTeX engine, powered by XeTeX and TeXLive";
    homepage = "https://tectonic-typesetting.github.io/";
    changelog = "https://github.com/tectonic-typesetting/tectonic/blob/tectonic@${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    mainProgram = "tectonic";
    maintainers = with maintainers; [ lluchs doronbehar bryango ];
  };
}
