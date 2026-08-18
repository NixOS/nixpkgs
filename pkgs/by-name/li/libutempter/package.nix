{
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  lib,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libutempter";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "altlinux";
    repo = "libutempter";
    tag = "${finalAttrs.version}-alt1";
    hash = "sha256-CiRZiEXzfOrtx1XXdMG2QZqzRtvY5mdA4SwTHRxkLUI=";
  };

  sourceRoot = "${finalAttrs.src.name}/libutempter";

  buildInputs = [ glib ];

  patches = [
    ./exec_path.patch
    (fetchpatch {
      name = "build-overwrite-already-existing-symlinks-during-ins.patch";
      url = "https://github.com/altlinux/libutempter/commit/717116b93d496a19f7f8abf8702517de0053f66e.patch";
      hash = "sha256-4YaxgbORNm+rlp0YzYKj5a7/zJl1dxo72i/Rei9qulg=";
    })
    ./Makefile-add-STATIC-and-DYNAMIC-build-variables.patch # https://github.com/altlinux/libutempter/pull/9
  ];

  patchFlags = [ "-p2" ];

  prePatch = ''
    substituteInPlace Makefile --replace 2711 0711
  '';

  makeFlags =
    lib.optionals stdenv.hostPlatform.isStatic [
      "DYNAMIC=0"
      "STATIC=1"
    ]
    ++ [
      "libdir=\${out}/lib"
      "libexecdir=\${out}/lib"
      "includedir=\${out}/include"
      "mandir=\${out}/share/man"
    ];

  meta = {
    homepage = "https://github.com/altlinux/libutempter";
    description = "Interface for terminal emulators such as screen and xterm to record user sessions to utmp and wtmp files";
    longDescription = ''
      The bundled utempter binary must be able to run as a user belonging to group utmp.
      On NixOS systems, this can be achieved by creating a setguid wrapper.
    '';
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.msteen ];
  };
})
