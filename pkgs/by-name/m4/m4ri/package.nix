{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  version = "20240729";
  pname = "m4ri";

  src = fetchFromGitHub {
    owner = "malb";
    repo = "m4ri";
    # 20240729 has a broken m4ri.pc file, fixed in the next commit.
    # TODO: remove if on update
    rev =
      if version == "20240729" then "775189bfea96ffaeab460513413fcf4fbcd64392" else "release-${version}";
    hash = "sha256-untwo0go8O8zNO0EyZ4n/n7mngSXLr3Z/FSkXA8ptnU=";
  };

  # based on the list in m4/m4_ax_ext.m4
  configureFlags = builtins.map (s: "ax_cv_have_${s}_cpu_ext=no") (
    [
      "sha"
      "xop"
    ]
    ++ lib.optional (!stdenv.hostPlatform.sse3Support) "sse3"
    ++ lib.optional (!stdenv.hostPlatform.ssse3Support) "ssse3"
    ++ lib.optional (!stdenv.hostPlatform.sse4_1Support) "sse41"
    ++ lib.optional (!stdenv.hostPlatform.sse4_2Support) "sse42"
    ++ lib.optional (!stdenv.hostPlatform.sse4_aSupport) "sse4a"
    ++ lib.optional (!stdenv.hostPlatform.aesSupport) "aes"
    ++ lib.optional (!stdenv.hostPlatform.avxSupport) "avx"
    ++ lib.optional (!stdenv.hostPlatform.fmaSupport) "fma3"
    ++ lib.optional (!stdenv.hostPlatform.fma4Support) "fma4"
    ++ lib.optional (!stdenv.hostPlatform.avx2Support) "avx2"
    ++ lib.optionals (!stdenv.hostPlatform.avx512Support) [
      "avx512f"
      "avx512cd"
      "avx512pf"
      "avx512er"
      "avx512vl"
      "avx512bw"
      "avx512dq"
      "avx512ifma"
      "avx512vbmi"
    ]
  );

  doCheck = true;

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = with lib; {
    homepage = "https://malb.bitbucket.io/m4ri/";
    description = "Library to do fast arithmetic with dense matrices over F_2";
    license = licenses.gpl2Plus;
    maintainers = teams.sage.members;
    platforms = platforms.unix;
  };
}
