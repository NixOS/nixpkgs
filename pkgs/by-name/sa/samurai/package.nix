{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "samurai";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "michaelforney";
    repo = "samurai";
    rev = version;
    hash = "sha256-RPY3MFlnSDBZ5LOkdWnMiR/CZIBdqIFo9uLU+SAKPBI=";
  };

  makeFlags = [
    "DESTDIR="
    "PREFIX=${placeholder "out"}"
  ];

  patches = [
    # NULL pointer dereference in writefile() in util.c; remove this at the next
    # release
    (fetchpatch {
      name = "CVE-2021-30218.patch";
      url = "https://github.com/michaelforney/samurai/commit/e84b6d99c85043fa1ba54851ee500540ec206918.patch";
      hash = "sha256-hyndwj6st4rwOJ35Iu0qL12dR5E6CBvsulvR27PYKMw=";
    })
    # NULL pointer dereference in printstatus() in build.c; remove this at the
    # next release
    (fetchpatch {
      name = "CVE-2021-30219.patch";
      url = "https://github.com/michaelforney/samurai/commit/d2af3bc375e2a77139c3a28d6128c60cd8d08655.patch";
      hash = "sha256-rcdwKjHeq5Oaga9wezdHSg/7ljkynfbnkBc2ciMW5so=";
    })
  ];

  meta = with lib; {
    description = "Ninja-compatible build tool written in C";
    longDescription = ''
      samurai is a ninja-compatible build tool with a focus on simplicity,
      speed, and portability.

      It is written in C99, requires various POSIX.1-2008 interfaces, and
      nowadays implements ninja build language through version 1.9.0 except for
      Microsoft (R) Visual C++ (TM) dependency handling (deps = msvc).

      It is feature-complete (but not bug-compatible) and supports most of the
      same options as ninja, using the same format for .ninja_log and
      .ninja_deps as the original ninja tool, currently version 5 and 4
      respectively.
    '';
    homepage = "https://github.com/michaelforney/samurai";
    license = with licenses; [
      mit
      asl20
    ]; # see LICENSE
    maintainers = with maintainers; [ dtzWill ];
    mainProgram = "samu";
    platforms = platforms.all;
  };
}
