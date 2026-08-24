{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rolespec";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "nickjj";
    repo = "rolespec";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-9t7aDfRYb5zJ+POnhx0BmsTVyWGRJwEzcsbJhdOvOBU=";
  };

  nativeBuildInputs = [ makeWrapper ];

  # The default build phase (`make`) runs the test code. It's difficult to do
  # the test in the build environment because it depends on the system package
  # managers (apt/yum/pacman). We simply skip this phase since RoleSpec is
  # shell based.
  dontBuild = true;

  # Wrap the program because `ROLESPEC_LIB` defaults to
  # `/usr/local/lib/rolespec`.
  installPhase = ''
    make install PREFIX=$out
    wrapProgram $out/bin/rolespec --set ROLESPEC_LIB $out/lib/rolespec
  '';

  # Since RoleSpec installs the shell script files in `lib` directory, the
  # fixup phase shows some warnings. Disable these actions.
  dontPatchELF = true;
  dontStrip = true;

  meta = {
    homepage = "https://github.com/nickjj/rolespec";
    description = "Test library for testing Ansible roles";
    mainProgram = "rolespec";
    longDescription = ''
      A shell based test library for Ansible that works both locally and over
      Travis-CI.
    '';
    downloadPage = "https://github.com/nickjj/rolespec";
    license = lib.licenses.gpl3;
    maintainers = [
      lib.maintainers.dochang
      lib.maintainers.lukas-sgx
    ];
    platforms = lib.platforms.unix;
  };
})
