{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  libsForQt5,
}:

# how to update:
# 1. check out the tag for the version in question
# 2. run `prefetch-npm-deps package-lock.json`
# 3. update npmDepsHash with the output of the previous step

buildNpmPackage rec {
  pname = "polonium";
  version = "1.0rc";

  src = fetchFromGitHub {
    owner = "zeroxoneafour";
    repo = "polonium";
    rev = "v" + version;
    hash = "sha256-AdMeIUI7ZdctpG/kblGdk1DBy31nDyolPVcTvLEHnNs=";
  };

  npmDepsHash = "sha256-kaT3Uyq+/JkmebakG9xQuR4Kjo7vk6BzI1/LffOj/eo=";

  dontConfigure = true;

  # the installer does a bunch of stuff that fails in our sandbox, so just build here and then we
  # manually do the install
  buildFlags = [
    "res"
    "src"
  ];

  nativeBuildInputs = with libsForQt5; [ plasma-framework ];

  dontNpmBuild = true;

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    plasmapkg2 --install pkg --packageroot $out/share/kwin/scripts

    runHook postInstall
  '';

  meta = with lib; {
    description = "Auto-tiler that uses KWin 6.0+ tiling functionality";
    license = licenses.mit;
    maintainers = with maintainers; [
      peterhoeg
      kotatsuyaki
      HeitorAugustoLN
    ];
    inherit (libsForQt5.plasma-framework.meta) platforms;
  };
}
