{
  lib,
  stdenv,
  ruby,
  rake,
  fetchFromGitHub,
  fetchpatch,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mruby";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "mruby";
    repo = "mruby";
    rev = finalAttrs.version;
    sha256 = "sha256-7CDTRQncpjY0HO0S1lM57aUvV6ZseEp+/nxXp4ZuuQs=";
  };

  nativeBuildInputs = [ rake ];

  nativeCheckInputs = [ ruby ];

  # Necessary so it uses `gcc` instead of `ld` for linking.
  # https://github.com/mruby/mruby/blob/e502fd88b988b0a8d9f31b928eb322eae269c45a/tasks/toolchains/gcc.rake#L30
  preBuild = "unset LD";

  installPhase = ''
    mkdir $out
    cp -R include build/host/{bin,lib} $out
  '';

  doCheck = true;

  checkTarget = "test";

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Embeddable implementation of the Ruby language";
    homepage = "https://mruby.org";
    maintainers = with lib.maintainers; [
      nicknovitski
      nomadium
    ];
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "mruby";
  };
})
