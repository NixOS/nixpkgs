{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  name = "kakoune-gdb";
  version = "2019-11-24";

  src = fetchFromGitHub {
    owner = "occivink";
    repo = name;
    rev = "57e2467e00a907d2bea798b66c56dcb5c1112efd";
    sha256 = "06djnkfjawfakh14gsg3bxj301yxkc8i6v02yzdaha1j4287lpra";
  };

  installPhase = ''
    mkdir -p $out/share/kak/autoload/plugins
    cp gdb.kak $out/share/kak/autoload/plugins
    cp gdb-output-handler.perl $out/share/kak/autoload/plugins
  '';

  meta = with stdenv.lib; {
    description = "A gdb integration plugin";
    homepage = "https://nixos.org/manual/nixpkgs/stable/";
    license = licenses.unlicense;
    platform = platforms.all;
    maintainers = with maintainers; [ buffet ];
  };
}
