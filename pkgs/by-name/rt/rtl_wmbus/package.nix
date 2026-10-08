{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  strictDeps = true;
  __structuredAttrs = true;

  pname = "rtl-wmbus";
  version = "1.1.0";
  src = fetchFromGitHub {
    owner = "xaelsouth";
    repo = "rtl-wmbus";
    tag = "${finalAttrs.version}";
    hash = "sha256-T8cYRkj7w4nAtcPvDkpPTwbDPXUr1qYZtyDtTjHWDMA=";

    # need to fetch revision from git
    leaveDotGit = true;
    postFetch = ''
      # avoid having the whole .git-folder
      substituteInPlace $out/Makefile --replace-fail "COMMIT_HASH?=\$(shell git log --pretty=format:'%H' -n 1)" "COMMIT_HASH:=$(git -C $out log --pretty=format:'%H' -n 1)"

      rm -rf $out/.git
    '';
  };

  # avoid reading the version from git to avoid fetching all tags
  makeFlags = [
    "TAG=${finalAttrs.version}"
    "BRANCH="
    "CHANGES="
  ];

  # make install would use /usr/bin
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp build/rtl_wmbus $out/bin

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Software defined receiver for Wireless-M-Bus with RTL-SDR";
    homepage = "https://github.com/xaelsouth/rtl-wmbus";
    license = lib.licenses.bsd2;
    mainProgram = "rtl_wmbus";
    maintainers = with lib.maintainers; [
      prauscher
    ];
  };
})
