{
  lib,
  stdenv,
  fetchFromGitHub,
  gcc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pnut";
  version = "1.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "udem-dlteam";
    repo = "pnut";
    tag = "pnut-${finalAttrs.version}";
    hash = "sha256-q0JoW8Tw25m+Hp9W/LxzC3yt78J1AmeV1G3h41RHIOI=";
  };

  preInstall = "mkdir -p $out/bin";

  installFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  # fixes a few tests due to
  # typedef int bool; deprecations
  env.NIX_CFLAGS_COMPILE = "-std=c17";

  # flaky test
  preCheck = ''
    rm tests/_sh/checks/sizeof_array.c
  '';
  doCheck = true;
  checkTarget = "test-sh";
  # test requires gcc due to some linking oddities
  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isDarwin [ gcc ];

  meta = {
    description = "C to POSIX shell transpiler";
    homepage = "https://github.com/udem-dlteam/pnut";
    changelog = "https://github.com/udem-dlteam/pnut/releases/tag/pnut-${finalAttrs.version}";
    license = lib.licenses.bsd2;
    teams = [ lib.teams.ngi ];
    mainProgram = "pnut";
    platforms = [
      "aarch64-darwin"
      "x86_64-linux"
    ];
  };
})
