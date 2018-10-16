{ lib, fetchFromGitHub, rustPlatform, newScope }:

let
  version = "2018-10-16";
  xi-editor-src = fetchFromGitHub {
    owner = "xi-editor";
    repo = "xi-editor";
    rev = "420d6e0653e6749bd5c58d2c32e9c88ff5b487a6";
    sha256 = "1fjq2gp8iyig6flr46vpiikr3jfv4jqb400v98lkhz23g9z4v0vr";
  };
  callPackage = newScope self;
  self = {
    xi-core = rustPlatform.buildRustPackage {
      name = "xi-core-${version}";
      inherit version;

      src = xi-editor-src;

      sourceRoot = "source/rust";

      cargoSha256 = "078cwlqdafa8mna2kmg9zbs4sd3g8dl07x9xqnmzswqgq8ds0fkk";

      #postInstall = ''
      #  make -C syntect-plugin install
      #'';

      meta = with lib; {
        description = "A modern editor with a backend written in Rust";
        homepage = https://github.com/xi-editor/xi-editor;
        license = licenses.asl20;
        maintainers = with maintainers; [ dtzWill ];
        platforms = platforms.all;
      };
    };
    wrapXiFrontendHook = callPackage ./wrapper.nix { };

    gxi = callPackage ./gxi { };
    kod = callPackage ./kod { };
    xi-term = callPackage ./xi-term { };
  };
in self
