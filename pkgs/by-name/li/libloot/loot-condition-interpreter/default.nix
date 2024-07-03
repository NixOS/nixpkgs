{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, callPackage
, p7zip
, rustPlatform
}:

let

  testing-plugins = callPackage ../testing-plugins.nix { };

in

rustPlatform.buildRustPackage rec {
  pname = "loot-condition-interpreter";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "loot";
    repo = pname;
    rev = version;
    hash = "sha256-hPDIx/Tc1JsiF0dcsQlrQJRfzLSFQbbUls0Q/dkwVwg=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${cargoLock.lockFile} Cargo.lock
  '';

  cargoBuildFlags = [ "--package" "loot-condition-interpreter-ffi" "--all-features" ];

  preCheck = ''
    tmp=$(mktemp -dp .)
    tar -C "$tmp" -xzf ${testing-plugins}
    (cd tests && ln -rs "../$tmp"/* testing-plugins)

    tmp=$(mktemp -dp .)
    ${p7zip}/bin/7z x -o"$tmp" ${fetchurl {
      url = "https://github.com/loot/libloot/releases/download/0.18.2/libloot-0.18.2-0-gb1a9e31_0.18.2-win32.7z";
      hash = "sha256-sy2DvQcyy4Yd6bgFEN/dq2yoNpxMP3A6aT3GZ64yUss=";
    }}
    (cd tests && ln -s "../$tmp"/* libloot_win32)

    tmp=$(mktemp -dp .)
    ${p7zip}/bin/7z x -o"$tmp" ${fetchurl {
      url = "https://github.com/loot/libloot/releases/download/0.18.2/libloot-0.18.2-0-gb1a9e31_0.18.2-win64.7z";
      hash = "sha256-gRkRQ5XmzPPYm3QZQY45CebX5koNWU7eVuB8Ojls3nM=";
    }}
    (cd tests && ln -s "../$tmp"/* libloot_win64)
  '';

  checkFlags = [
    # We don't want to download, extract, and then fix-up another archive
    # for those two tests.
    "--skip=function::version::tests::constructors::version_read_file_version_should_return_none_if_there_is_no_version_info"
    "--skip=function::version::tests::constructors::version_read_product_version_should_return_none_if_there_is_no_version_info"
  ];

  # FIXME
  postInstall = ''
    cp -r ffi/include $out/include
  '';

  meta = with lib; {
    description = "A library for parsing and evaluating LOOT's metadata condition strings";
    homepage = "https://github.com/loot/loot-condition-interpreter";
    license = licenses.mit;
    maintainers = [ maintainers.schnusch ];
  };
}
