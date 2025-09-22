{
  lib,
  stdenv,
  fetchFromGitHub,
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
stdenv.mkDerivation rec {
  pname = "skktools";
  version = "1.3.4";
  src = fetchFromGitHub {
    owner = "skk-dev";
    repo = "skktools";
    rev = "skktools-${lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "1zway8jsm18279xq8zlpr84iqiw373x3v0ysay74n9bjqxbl234a";
  };
  # # See "12.2. Package naming"
  # name = "skktools-unstable-${version}";
  # version = "2017-03-05";
  # src = fetchFromGitHub {
  #   owner = "skk-dev";
  #   repo = "skktools";
  #   rev = "e14d98e734d2fdff611385c7df65826e94d929db";
  #   sha256 = "1k9zxqybl1l5h0a8px2awc920qrdyp1qls50h3kfrj3g65d08aq2";
  # };

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
}
