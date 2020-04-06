{ appimageTools, fetchurl, lib }:

let
  pname = "marktext";
  version = "v0.16.0-rc.2";
in
appimageTools.wrapType2 rec {
  name = "${pname}-${version}-binary";

  src = fetchurl {
    url = "https://github.com/marktext/marktext/releases/download/${version}/marktext-x86_64.AppImage";
    sha256 = "1w1mxa1j94zr36xhvlhzq8d77pi359vdxqb2j8mnz2bib9khxk9k";
  };

  profile = ''
    export LC_ALL=C.UTF-8
  '';

  multiPkgs = null; # no 32bit needed
  extraPkgs = p: (appimageTools.defaultFhsEnvArgs.multiPkgs p) ++ [
    p.libsecret
    p.xlibs.libxkbfile
  ];

  # Strip version from binary name.
  extraInstallCommands = "mv $out/bin/${name} $out/bin/${pname}";

  meta = with lib; {
    description = "A simple and elegant markdown editor, available for Linux, macOS and Windows.";
    homepage = "https://marktext.app";
    license = licenses.mit;
    maintainers = with maintainers; [ nh2 ];
    platforms = [ "x86_64-linux" ];
  };
}
