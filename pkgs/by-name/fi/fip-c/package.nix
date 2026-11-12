{
  stdenv,
  fetchFromGitHub,
  linkFarm,
  lib,
  zig_0_17,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fip-c";
  date = "2026-11-12";
  version = "0.4.2-0-unstable-${finalAttrs.date}";

  src = fetchFromGitHub {
    owner = "flint-lang";
    repo = "fip-c";
    rev = "9193ec13bfdab31387578004f0f1951a3a9b05b4";
    sha256 = "sha256-ZNDLoqkp9DCD3iWp1VyHrS+M5lSYtZoPaWpaOw5zigc=";
  };

  aroSrc = fetchFromGitHub {
    owner = "Vexu";
    repo = "arocc";
    rev = "c12999712585f9d67acc290c4ba51e89ec1d7fb5";
    sha256 = "sha256-2jXt1rgNPU2PU5P/kT+TzQDgGaunUiIJwoeCgOsPMsI=";
  };

  clapSrc = fetchFromGitHub {
    owner = "Hejsil";
    repo = "zig-clap";
    rev = "05faf3905e8548f5cc269a8836e154065e70128d";
    sha256 = "sha256-8d5Rs7mwjSSr3qA0MpanIBo7ZbgAwm3u12/j0JhnZNg=";
  };

  fipSrc = fetchFromGitHub {
    owner = "flint-lang";
    repo = "fip";
    rev = "306dc342e37258832bdc216c049cd3cdaa312245";
    sha256 = "sha256-0uq9njGpKQ77Oz3PYocQnGu4xz9SO14Y/AhVJJ1GWzA=";
  };

  tomlc17Src = fetchFromGitHub {
    owner = "cktan";
    repo = "tomlc17";
    rev = "R250712";
    sha256 = "sha256-0if07Zj7Og+DBc/gxmAEHQh7QwAo8C/4S+x9IttEUjI=";
  };

  # We construct our own 'zig-pkg' dir Zig then uses, so we still have control over fetching the dependencies before building
  zigPkgDir = linkFarm "fip-c-zig-pkg" [
    {
      name = "aro-0.0.0-JSD1QieDNwCxnCLH968EXw7cC_HFWpJ1Km0J6B_8gNzM";
      path = finalAttrs.aroSrc;
    }
    {
      name = "clap-0.12.0-oBajB4XpAQCF1WRKnD5KOKPsnwwT_NNdAJ7Ww3irYJac";
      path = finalAttrs.clapSrc;
    }
    {
      name = "fip-0.4.1-jXH3OV_oAgBzsf1MwFW1bfnemaM6u9wd3lgM5Fdpxxpo";
      path = finalAttrs.fipSrc;
    }
    {
      name = "N-V-__8AAFeHAgBabNQUR0r3Nw2q1AtSvpwQVLt8ihh50mYO";
      path = finalAttrs.tomlc17Src;
    }
  ];

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    zig_0_17
  ];

  dontSetZigDefaultFlags = true;
  enableParallelBuilding = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.zigPkgDir}"
    "-Dcommit-hash=${builtins.substring 0 7 finalAttrs.src.rev}"
    "-Dcommit-date=${finalAttrs.date}"
    "--release=small"
  ];

  meta = with lib; {
    description = "C Interop Module utilizing the Flint Interop Protocol";
    homepage = "https://github.com/flint-lang/fip-c";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zweiler1 ];
    mainProgram = "fip-c";
  };
})
