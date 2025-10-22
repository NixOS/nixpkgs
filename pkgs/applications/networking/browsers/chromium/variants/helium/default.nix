{
  stdenv,
  fetchFromGitHub,
  python3,
  makeWrapper,
  fetchpatch,
  patch,
}:

{
  rev,
  hash,
}:

stdenv.mkDerivation {
  pname = "helium";

  version = rev;

  src = fetchFromGitHub {
    owner = "imputnet";
    repo = "helium";
    inherit rev hash;
  };

  buildPhase = ''
    runHook preBuild
    python3 ./utils/generate_resources.py ./resources/generate_resources.txt ./resources
    sed -i '/chromium-widevine/d' patches/series
    runHook postBuild
  '';

  buildInputs = [
    (python3.withPackages (
      ps: with ps; [
        pillow
      ]
    ))
    patch
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    mkdir $out
    cp -R * $out/
    wrapProgram $out/utils/patches.py --add-flags "apply" --prefix PATH : "${patch}/bin"

    # Upstream didn't mark some of the scripts as executable.
    # TODO: Should be removed after https://github.com/imputnet/helium/pull/234 is merged.
    chmod +x $out/utils/{generate_resources,helium_version,name_substitution,replace_resources}.py
  '';
}
