{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeBinaryWrapper,
  nix-update-script,
  runCommand,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stdoutisatty";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "lilydjwg";
    repo = "stdoutisatty";
    rev = finalAttrs.version;
    hash = "sha256-NyVn9cxx0rY1ridNDTqe0pzcVhdLVaPCKT4hoQkQzRs=";
  };

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
  ];

  cmakeFlags = [
    # must specify the full path to `libstdoutisatty.so` in the nix store
    (lib.cmakeFeature "CMAKE_C_FLAGS" "-DLIB_FILE='\"${placeholder "out"}/lib/libstdoutisatty.so\"'")
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      ls-color = runCommand "${finalAttrs.pname}-test-ls-color" { } ''
        set -x
        mkdir somedir
        ln -s somedir somelink

        color_auto=$(ls -1 --color=auto)
        color_always=$(ls -1 --color=always)

        ${lib.getExe finalAttrs.finalPackage} \
          ls -1 --color=auto > $out

        [[ "$(cat $out)" == "$color_always" ]]
        [[ "$(cat $out)" != "$color_auto" ]]
        set +x
      '';
    };
  };

  meta = {
    description = "Make programs think their stdout is a tty / terminal";
    longDescription = ''
      `stdoutisatty command` makes `command` think their stdout is a terminal,
      even if it is actually being piped into another program (e.g. `less`).
      This is most useful for preserving user-friendly, colored outputs.

      For example, `stdoutisatty ls --color=auto | less` will always show
      colored output, despite being piped into a pager.
    '';
    homepage = "https://github.com/lilydjwg/stdoutisatty";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ bryango ];
    mainProgram = "stdoutisatty";
    platforms = lib.platforms.linux;
  };
})
