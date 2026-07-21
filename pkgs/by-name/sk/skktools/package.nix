{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  gdbm,
  glib,
}:

# Note (2017-10-24, yuriaisaka):
# - Version 1.3.3 dates from Jul. 19, 2013.
# - The latest commit to the github repo dates from Mar. 05, 2017
# - The repo since appears to have become a kitchen sink place to keep
#   misc tools to handle SKK dictionaries, and these tools have runtime
#   dependencies on a Ruby interpreter etc.
# - We for the moment do not package them to keep the dependencies slim.
#   Probably, shall package the newer tools as skktools-extra in the future.
stdenv.mkDerivation (finalAttrs: {
  pname = "skktools";
  version = "1.3.4";
  src = fetchFromGitHub {
    owner = "skk-dev";
    repo = "skktools";
    rev = "skktools-${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    sha256 = "1zway8jsm18279xq8zlpr84iqiw373x3v0ysay74n9bjqxbl234a";
  };
  # # See "12.2. Package naming"
  # name = "skktools-unstable-${finalAttrs.version}";
  # version = "2017-03-05";
  # src = fetchFromGitHub {
  #   owner = "skk-dev";
  #   repo = "skktools";
  #   rev = "e14d98e734d2fdff611385c7df65826e94d929db";
  #   sha256 = "1k9zxqybl1l5h0a8px2awc920qrdyp1qls50h3kfrj3g65d08aq2";
  # };

  patches = [
    # Fix build with gcc15
    # https://github.com/skk-dev/skktools/pull/30
    (fetchpatch {
      name = "skktools-fix-function-prototype-empty-arguments-gcc15.patch";
      url = "https://github.com/skk-dev/skktools/commit/fb6a295607dbe2b5171c2c89f8a2f0b82bee9766.patch";
      hash = "sha256-wao2kRsDq5WN4JO/YpXhNirsdnA3vZpsY9GDCTPSJKY=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gdbm
    glib
  ];

  meta = {
    description = "Collection of tools to edit SKK dictionaries";
    longDescription = ''
      This package provides a collection of tools to manipulate
      (merge, sort etc.) the dictionaries formatted for SKK Japanese
      input method.
    '';
    homepage = "https://github.com/skk-dev/skktools";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ yuriaisaka ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
