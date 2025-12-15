{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "rtl-wmbus";
  version = "d2be82c";

  src = fetchFromGitHub {
    owner = "xaelsouth";
    repo = "rtl-wmbus";
    tag = version;
    hash = "sha256-TbNOvEyG0vNG68UpKRwJYDcUiDWTujneSD0Vx/4eFrA=";

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
    "TAG=${version}"
    "BRANCH="
    "CHANGES="
  ];

  # make install would use /usr/bin
  installPhase = ''
    mkdir -p $out/bin
    cp build/rtl_wmbus $out/bin
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Software defined receiver for Wireless-M-Bus with RTL-SDR";
    homepage = "https://github.com/xaelsouth/rtl-wmbus";
    license = lib.licenses.bsd2;
    mainProgram = "rtl_wmbus";
  };
}
