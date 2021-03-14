{ stdenv
, fetchFromGitHub
, python3Packages
, makeWrapper
, patch
}:

{ rev
, sha256
}:

stdenv.mkDerivation rec {
  name = "ungoogled-chromium-${version}";

  version = rev;

  src = fetchFromGitHub {
    owner = "Eloston";
    repo = "ungoogled-chromium";
    inherit rev sha256;
  };

  dontBuild = true;

  buildInputs = [
    python3Packages.python
    patch
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  patchPhase = ''
    sed -i '/chromium-widevine/d' patches/series
  '';

  installPhase = ''
    mkdir $out
    cp -R * $out/
    wrapProgram $out/utils/patches.py --add-flags "apply" --prefix PATH : "${patch}/bin"
  '';
}
