{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  lttng-tools,
  libatomic_ops,
  perl,
  coreutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmsquic";
  version = "2.4.8";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "msquic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cgLrTcoa77XuVsMBvOWw9oKoNtD1ihJM553YpZ+GzQQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    perl
  ];

  buildInputs = [
    lttng-tools
    libatomic_ops
  ];

  postUnpack = ''
    for f in "$(find . -type f -name "*.pl")"; do
      patchShebangs --build $f 2>&1 > /dev/null
    done

    for g in $(find . -type f -name "*" ); do
      if test -f $g; then
        sed -i "s|/usr/bin/env|${coreutils}/bin/env|g" $g
      fi
    done
  '';

  meta = {
    description = "Cross-platform, C implementation of the IETF QUIC protocol, exposed to C, C++, C# and Rust";
    homepage = "https://github.com/microsoft/msquic";
    changelog = "https://github.com/microsoft/msquic/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ SohamG ];
  };
})
