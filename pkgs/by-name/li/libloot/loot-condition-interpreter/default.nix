{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, callPackage
, p7zip
, rustPlatform
, rust-cbindgen
}:

let

  testing-plugins = callPackage ../testing-plugins.nix { };

in

rustPlatform.buildRustPackage rec {
  pname = "loot-condition-interpreter";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "loot";
    repo = pname;
    rev = version;
    hash = "sha256-sFdtpf+TaKfAbvK5oplb77uAIRdcLw3XfGYYVZ37XAM=";
  };

  cargoHash = "sha256-h0Lm/jzCzD19JrJYk5yp8XvbhFNO3LKGbS7WPyw0GDk=";

  nativeBuildInputs = [
    rust-cbindgen
  ];

  preConfigure = ''
    cd ffi
  '';

  postBuild = ''
    # manually since 4.0.0
    cbindgen . -o include/loot_condition_interpreter.h
    cd ..
  '';

  preCheck = ''
    # tests/testing-plugins must be writable
    cp -r ${testing-plugins} tests/testing-plugins
    chmod -R u+w tests/testing-plugins

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

    # needed by:
    # function::version::tests::constructors::version_read_file_version_should_return_none_if_there_is_no_version_info
    # function::version::tests::constructors::version_read_product_version_should_return_none_if_there_is_no_version_info
    tmp=$(mktemp -dp .)
    ${p7zip}/bin/7z x -o"$tmp" ${fetchurl {
      url = "https://github.com/loot/loot-api-python/releases/download/4.0.2/loot_api_python-4.0.2-0-gd356ac2_master-python2.7-win32.7z";
      hash = "sha256-g6iYRGsT63PfACNHAnwPXdit+aQEyE7KZdtXEDCP+vw=";
    }}
    (cd tests && ln -s "../$tmp"/* loot_api_python)
  '';

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
