{
  lib,
  stdenv,
  fetchFromGitHub,
  mbrola,
  languages ? [ ],
}:

let
  src = fetchFromGitHub {
    owner = "numediart";
    repo = "MBROLA-voices";
    rev = "fe05a0ccef6a941207fd6aaad0b31294a1f93a51";
    hash = "sha256-QBUggnde5iNeCESzxE0btVVTDOxc3Kdk483mdGUXHvA=";
    inherit pname version meta;
  };

  pname = "mbrola-voices";
  version = "0-unstable-2020-03-30";
  meta = {
    description = "Speech synthesizer based on the concatenation of diphones (voice files)";
    homepage = "https://github.com/numediart/MBROLA-voices";
    license = mbrola.meta.license;
  };
in

stdenv.mkDerivation {
  inherit src;

  __structuredAttrs = true;
  strictDeps = true;

  postPatch = lib.optionalString (languages != [ ]) ''
    shopt -s extglob
    pushd data
    rm -rfv !(${lib.concatStringsSep "|" languages})
    popd
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/mbrola
    cp -R data/* $out/share/mbrola
    runHook postInstall
  '';

  inherit
    pname
    version
    meta
    ;
}
