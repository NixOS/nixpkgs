{ lib
, stdenv
, fetchFromGitHub
, nix-update-script

, cmake
, mimalloc
, ninja
, tbb
, zlib
, zstd

, buildPackages
, clangStdenv
, gccStdenv
, hello
, mold
, mold-wrapped
, runCommandCC
, testers
, useMoldLinker
}:

stdenv.mkDerivation rec {
  pname = "mold";
  version = "2.31.0";

  src = fetchFromGitHub {
    owner = "rui314";
    repo = "mold";
    rev = "v${version}";
    hash = "sha256-CUIk1YACM+eCuxyUqyKaVBF00Ybxr23D+FQuXv45Qrs=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    tbb
    zlib
    zstd
  ] ++ lib.optionals (!stdenv.isDarwin) [
    mimalloc
  ];

  cmakeFlags = [
    "-DMOLD_USE_SYSTEM_MIMALLOC:BOOL=ON"
    "-DMOLD_USE_SYSTEM_TBB:BOOL=ON"
  ];

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.isDarwin [
    "-faligned-allocation"
  ]);

  passthru = {
    updateScript = nix-update-script { };
    tests =
      let
        helloTest = name: helloMold:
          let
            command = "$READELF -p .comment ${lib.getExe helloMold}";
            emulator = stdenv.hostPlatform.emulator buildPackages;
          in
          runCommandCC "mold-${name}-test" { passthru = { inherit helloMold; }; }
            ''
              echo "Testing running the 'hello' binary which should be linked with 'mold'" >&2
              ${emulator} ${lib.getExe helloMold}

              echo "Checking for mold in the '.comment' section" >&2
              if output=$(${command} 2>&1); then
                if grep -Fw -- "mold" - <<< "$output"; then
                  touch $out
                else
                  echo "No mention of 'mold' detected in the '.comment' section" >&2
                  echo "The command was:" >&2
                  echo "${command}" >&2
                  echo "The output was:" >&2
                  echo "$output" >&2
                  exit 1
                fi
              else
                echo -n "${command}" >&2
                echo " returned a non-zero exit code." >&2
                echo "$output" >&2
                exit 1
              fi
            ''
        ;
      in
      {
        version = testers.testVersion { package = mold; };
      } // lib.optionalAttrs stdenv.isLinux {
        adapter-gcc = helloTest "adapter-gcc" (hello.override (old: { stdenv = useMoldLinker gccStdenv; }));
        adapter-llvm = helloTest "adapter-llvm" (hello.override (old: { stdenv = useMoldLinker clangStdenv; }));
        wrapped = helloTest "wrapped" (hello.overrideAttrs (previousAttrs: {
          nativeBuildInputs = (previousAttrs.nativeBuildInputs or [ ]) ++ [ mold-wrapped ];
          NIX_CFLAGS_LINK = toString (previousAttrs.NIX_CFLAGS_LINK or "") + " -fuse-ld=mold";
        }));
      };
  };

  meta = with lib; {
    description = "Faster drop-in replacement for existing Unix linkers (unwrapped)";
    longDescription = ''
      mold is a faster drop-in replacement for existing Unix linkers. It is
      several times faster than the LLVM lld linker. mold is designed to
      increase developer productivity by reducing build time, especially in
      rapid debug-edit-rebuild cycles.
    '';
    homepage = "https://github.com/rui314/mold";
    changelog = "https://github.com/rui314/mold/releases/tag/v${version}";
    license = licenses.mit;
    platforms = platforms.unix;
    mainProgram = "mold";
    maintainers = with maintainers; [ azahi paveloom ];
  };
}
