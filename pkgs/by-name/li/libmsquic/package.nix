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
<<<<<<< HEAD
  version = "2.5.6";
=======
  version = "2.5.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "msquic";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-Nq7iIOz9duThWQSjJTGK+xnKEH3H3ck9v37ppoGFaEE=";
=======
    hash = "sha256-V1QAY1E6prAtEDkUVOuBExHaDw91+fW3OKYZr2bQavQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    perl
  ];

  buildInputs = [
    libatomic_ops
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    lttng-tools
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
