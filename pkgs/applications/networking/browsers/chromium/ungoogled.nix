{
  stdenv,
  fetchFromGitHub,
  python3Packages,
  makeWrapper,
  patch,
}:

{
  rev,
  hash,
}:

stdenv.mkDerivation {
  pname = "ungoogled-chromium";

  version = rev;

  src = fetchFromGitHub {
    owner = "ungoogled-software";
    repo = "ungoogled-chromium";
    inherit rev hash;
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
