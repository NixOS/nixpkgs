{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,
  testers,
  nix-update-script,
}:
let
  tools = [
    "apfsck"
    "apfs-label"
    "apfs-snap"
    "mkapfs"
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "apfsprogs";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "linux-apfs";
    repo = "apfsprogs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GhhuielfFvcpe9hL3fUcg2xlwFrzjiUS/ZLn0jkfkh8=";
  };

  postPatch = ''
    substituteInPlace \
      apfs-snap/Makefile apfsck/Makefile mkapfs/Makefile apfs-label/Makefile \
      --replace-fail \
        '$(shell git describe --always HEAD | tail -c 9)' \
        'v${finalAttrs.version}'
  '';

  buildPhase = ''
    runHook preBuild
    make -C apfs-snap $makeFlags
    make -C apfsck $makeFlags
    make -C mkapfs $makeFlags
    make -C apfs-label $makeFlags
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make -C apfs-snap install DESTDIR="$out" $installFlags
    make -C apfsck install DESTDIR="$out" $installFlags
    make -C mkapfs install DESTDIR="$out" $installFlags
    make -C apfs-label install DESTDIR="$out" $installFlags
    runHook postInstall
  '';

  passthru.tests =
    let
      mkVersionTest = tool: {
        "version-${tool}" = testers.testVersion {
          package = finalAttrs.finalPackage;
          command = "${tool} -v";
          version = "v${finalAttrs.version}";
        };
      };
      versionTestList = map mkVersionTest tools;

      versionTests = lib.mergeAttrsList versionTestList;
    in
    {
      apfs = nixosTests.apfs;
    }
    // versionTests;

  passthru.updateScript = nix-update-script { };

  strictDeps = true;

  meta = with lib; {
    description = "Experimental APFS tools for linux";
    homepage = "https://github.com/linux-apfs/apfsprogs";
    changelog = "https://github.com/linux-apfs/apfsprogs/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Luflosi ];
  };
})
