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
  };

  meta = {
    description = "Speech synthesizer based on the concatenation of diphones (voice files)";
    homepage = "https://github.com/numediart/MBROLA-voices";
    license = mbrola.meta.license;
  };
in

if (languages == [ ]) then
  src // { inherit meta; }
else
  stdenv.mkDerivation {
    pname = "mbrola-voices";
    version = "0-unstable-2020-03-30";

    inherit src;

    postPatch = ''
      shopt -s extglob
      pushd data
      rm -rfv !(${lib.concatStringsSep "|" languages})
      popd
    '';

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp -R data $out/

      runHook postInstall
    '';

    inherit meta;
  }
