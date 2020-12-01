# Table of contents
#
# This file is `_toc.yml` but in Nix.
# https://jupyterbook.org/customize/toc.html
#
[
  {
    file = "doc/preface.md";
  }
  {
    part = "Using Nixpkgs";
    chapters = [
      {
        file = "doc/using/configuration.md";
      }
      {
        file = "doc/using/overlays.md";
      }
      {
        file = "doc/using/overrides.md";
      }
      {
        file = "doc/functions.md";
        sections = [
          {
            file = "doc/functions/debug";
          }
          {
            file = "doc/functions/generators";
          }
          {
            file = "doc/functions/library";
            sections = [
              {
                file = "doc/functions/library/asserts";
              }
              {
                file = "doc/functions/library/attrsets";
              }
            ];
          }
          {
            file = "doc/functions/nix-gitignore";
          }
          {
            file = "doc/functions/prefer-remote-fetch";
          }
        ];
      }
    ];
  }
  {
    part = "Standard environment";
    chapters = [
      {
        file = "doc/stdenv/stdenv.md";
      }
      {
        file = "doc/stdenv/meta.md";
      }
      {
        file = "doc/stdenv/multiple-output.md";
      }
      {
        file = "doc/stdenv/cross-compilation.md";
      }
      {
        file = "doc/stdenv/platform-notes.md";
      }
    ];
  }
  {
    part = "Builders";
    chapters = [
      {
        file = "doc/builders/fetchers.md";
      }
      {
        file = "doc/builders/trivial-builders.md";
      }
      {
        file = "doc/builders/special.md";
        sections = [
          {
            file = "doc/builders/special/fhs-environments";
          }
          {
            file = "doc/builders/special/mkshell";
          }
        ];
      }
      {
        file = "doc/builders/images.md";
        sections = [
          {
            file = "doc/builders/images/appimagetools";
          }
          {
            file = "doc/builders/images/dockertools";
          }
          {
            file = "doc/builders/images/ocitools";
          }
          {
            file = "doc/builders/images/snaptools";
          }
        ];
      }
      {
        file = "doc/languages-frameworks/index.md";
        sections = [
          {
            file = "doc/languages-frameworks/agda";
          }
          {
            file = "doc/languages-frameworks/android";
          }
          {
            file = "doc/languages-frameworks/beam";
          }
          {
            file = "doc/languages-frameworks/bower";
          }
          {
            file = "doc/languages-frameworks/coq";
          }
          {
            file = "doc/languages-frameworks/crystal";
          }
          {
            file = "doc/languages-frameworks/dotnet";
          }
          {
            file = "doc/languages-frameworks/emscripten";
          }
          {
            file = "doc/languages-frameworks/gnome";
          }
          {
            file = "doc/languages-frameworks/go";
          }
          {
            file = "doc/languages-frameworks/haskell";
          }
          {
            file = "doc/languages-frameworks/idris";
          }
          {
            file = "doc/languages-frameworks/ios";
          }
          {
            file = "doc/languages-frameworks/java";
          }
          {
            file = "doc/languages-frameworks/lua";
          }
          {
            file = "doc/languages-frameworks/maven";
          }
          {
            file = "doc/languages-frameworks/node";
          }
          {
            file = "doc/languages-frameworks/ocaml";
          }
          {
            file = "doc/languages-frameworks/perl";
          }
          {
            file = "doc/languages-frameworks/php";
          }
          {
            file = "doc/languages-frameworks/python";
          }
          {
            file = "doc/languages-frameworks/qt";
          }
          {
            file = "doc/languages-frameworks/r";
          }
          {
            file = "doc/languages-frameworks/ruby";
          }
          {
            file = "doc/languages-frameworks/rust";
          }
          {
            file = "doc/languages-frameworks/texlive";
          }
          {
            file = "doc/languages-frameworks/titanium";
          }
          {
            file = "doc/languages-frameworks/vim";
          }
        ];
      }
      {
        file = "doc/builders/packages/index.md";
        sections = [
          {
            file = "doc/builders/packages/cataclysm-dda";
          }
          {
            file = "doc/builders/packages/citrix";
          }
          {
            file = "doc/builders/packages/dlib";
          }
          {
            file = "doc/builders/packages/eclipse";
          }
          {
            file = "doc/builders/packages/elm";
          }
          {
            file = "doc/builders/packages/emacs";
          }
          {
            file = "doc/builders/packages/ibus";
          }
          {
            file = "doc/builders/packages/kakoune";
          }
          {
            file = "doc/builders/packages/linux";
          }
          {
            file = "doc/builders/packages/locales";
          }
          {
            file = "doc/builders/packages/nginx";
          }
          {
            file = "doc/builders/packages/opengl";
          }
          {
            file = "doc/builders/packages/shell-helpers";
          }
          {
            file = "doc/builders/packages/steam";
          }
          {
            file = "doc/builders/packages/unfree";
          }
          {
            file = "doc/builders/packages/urxvt";
          }
          {
            file = "doc/builders/packages/weechat";
          }
          {
            file = "doc/builders/packages/xorg";
          }
        ];
      }
    ];
  }
  {
    part = "Contributing to Nixpkgs";
    chapters = [
      {
        file = "doc/contributing/quick-start";
      }
      {
        file = "doc/contributing/coding-conventions";
      }
      {
        file = "doc/contributing/submitting-changes";
      }
      {
        file = "doc/contributing/reviewing-contributions";
      }
      {
        file = "doc/contributing/contributing-to-documentation";
      }
    ];
  }
]
