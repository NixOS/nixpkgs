{
  lib,
  stdenv,
  fetchgit,
  testers,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sbase";
  version = "0.1-unstable-2025-09-19";

  src = fetchgit {
    url = "https://git.suckless.org/sbase";
    rev = "a0998d0252cff0bce7c2e41505b2505f536ae964";
    hash = "sha256-ehGCPRPLAh+tRBoIODS+/qOkg4UTOtvjAJ3sVuKX8+g=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  postPatch = ''
    cat >> compat.h <<'EOF'

    #if defined(__APPLE__)
    #define st_atim st_atimespec
    #define st_mtim st_mtimespec
    #define st_ctim st_ctimespec

    extern int chroot(const char *);
    #endif
    EOF
  '';

  NIX_CFLAGS_COMPILE = lib.optionals stdenv.isDarwin [
    "-D_DARWIN_C_SOURCE"
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  buildFlags = [ "sbase-box" ];
  installTargets = [ "sbase-box-install" ];

  passthru = {
    updateScript = unstableGitUpdater { };

    tests = {
      boxSha256 = testers.runCommand {
        name = "sbase-box-sha256";
        buildInputs = [ finalAttrs.finalPackage ];
        script = ''
          expected=ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad
          printf abc > f
          set -- $(sha256sum f);            [ "$1" = "$expected" ]
          set -- $(sbase-box sha256sum f);  [ "$1" = "$expected" ]
          touch $out
        '';
      };

      copyRoundtrip = testers.runCommand {
        name = "sbase-copy-roundtrip";
        buildInputs = [ finalAttrs.finalPackage ];
        script = ''
          echo 12345 > a
          cp a b
          cmp -s a b
          touch $out
        '';
      };

      echoUpper = testers.runCommand {
        name = "sbase-echo-upper";
        buildInputs = [ finalAttrs.finalPackage ];
        script = ''
          printf Hello | tr '[:lower:]' '[:upper:]' | grep -qx HELLO
          touch $out
        '';
      };

      whichWhichIsBox = testers.runCommand {
        name = "sbase-which-which-is-box";
        buildInputs = [ finalAttrs.finalPackage ];
        script = ''
          [ $(which which) -ef $(which sbase-box) ]
          touch $out
        '';
      };
    };
  };

  meta = {
    description = "Small, portable base system utilities from suckless.org";
    homepage = "https://core.suckless.org/sbase/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "sbase-box";
    maintainers = with lib.maintainers; [ Zaczero ];
  };
})
