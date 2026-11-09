{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  python3,
  autoconf,
  automake,
  libtool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ctemplate";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "OlafvdSpek";
    repo = "ctemplate";
    rev = "ctemplate-${finalAttrs.version}";
    sha256 = "1x0p5yym6vvcx70pm8ihnbxxrl2wnblfp72ih5vjyg8mzkc8cxrr";
  };

  patches = [
    # C++20 (the default with GCC 16) removed the
    # std::allocated::<T>::const_pointer typedef which ctemplate used. It was
    # ignored anyway, so we fetch the patch which removes this unused hint.
    (fetchpatch {
      name = "c++20-std-allocator-const-pointer-typedef.patch";
      url = "https://github.com/OlafvdSpek/ctemplate/commit/5aa5a00e74ea8a1ea22d6a9760b4b420687fa4e5.patch";
      hash = "sha256-Yqp7MOOdH/W09OQ2JkyAlert1UMoA/GS+6PT9WKVVEo=";
    })
  ];

  nativeBuildInputs = [
    python3
    autoconf
    automake
    libtool
  ];

  postPatch = ''
    patchShebangs .
  '';

  preConfigure = ''
    ./autogen.sh
  '';

  meta = {
    description = "Simple but powerful template language for C++";
    longDescription = ''
      CTemplate is a simple but powerful template language for C++. It
      emphasizes separating logic from presentation: it is impossible to
      embed application logic in this template language.
    '';
    homepage = "https://github.com/OlafvdSpek/ctemplate";
    license = lib.licenses.bsd3;
  };
})
