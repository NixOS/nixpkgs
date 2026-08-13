{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,

  # Test-only
  dash,
  ksh,
  zsh,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shellspec";
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "shellspec";
    repo = "shellspec";
    rev = finalAttrs.version;
    sha256 = "1ib5qp29f2fmivwnv6hq35qhvdxz42xgjlkvy0i3qn758riyqf46";
  };

  strictDeps = true;
  buildInputs = [ bash ];
  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  checkPhase = ''
    ./shellspec --no-banner --task fixture:stat:prepare
    ./shellspec --no-banner spec --jobs "$(nproc)" ${finalAttrs.extraTestArgs or ""}
  '';

  # "Building" the script happens in Docker
  dontBuild = true;

  passthru.tests =
    let
      # Tests are not enabled by default, so enable them.
      enabled = finalAttrs.overrideAttrs { doCheck = true; };
      # For adding variations. Use testWith (finalAttrs: prevAttrs: { }) if needed.
      testWith = enabled.overrideAttrs;
    in
    {
      # Enable tests in all variations
      # Some of these may log failures, which are later treated as SKIPPED.
      # This is normal. Look for "0 failures" and a successful derivation build.
      with-bin-sh = enabled;
      with-bash = testWith { extraTestArgs = "--shell ${lib.getExe bash}"; };
      # with-dash: Broken as of shellspec 0.28.1, dash 0.5.13.1
      # with-dash = testWith { extraTestArgs = "--shell ${lib.getExe dash}"; };
      with-ksh = testWith { extraTestArgs = "--shell ${lib.getExe ksh}"; };
      with-zsh = testWith { extraTestArgs = "--shell ${lib.getExe zsh}"; };
    };

  meta = {
    description = "Full-featured BDD unit testing framework for bash, ksh, zsh, dash and all POSIX shells";
    homepage = "https://shellspec.info/";
    changelog = "https://github.com/shellspec/shellspec/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ j0hax ];
    platforms = lib.platforms.unix;
    mainProgram = "shellspec";
  };
})
