{ stdenv, fetchFromGitHub, fetchpatch }:

let

patch-base = "https://github.com/LukeSmithxyz/kjv/commit/";

add-apocrypha = fetchpatch {
  url = patch-base + "b92b7622285d10464f9274f11e740bef90705bbc.patch";
  sha256 = "0n4sj8p9m10fcair4msc129jxkkx5whqzhjbr5k4lfgp6nb1zk8k";
};

add-install-target = fetchpatch {
  url = patch-base + "f4ad73539eb73f1890f4b791d8d38dd95900a4a4.patch";
  sha256 = "1yzj72i5fkzn2i4wl09q6jx7nwn2h4jwm49fc23nxfwchzar9m1q";
};

in

stdenv.mkDerivation rec {
  pname = "kjv";
  version = "unstable-2018-12-25";

  src = fetchFromGitHub {
    owner = "bontibon";
    repo = pname;
    rev = "fda81a610e4be0e7c5cf242de655868762dda1d4";
    sha256 = "1favfcjvd3pzz1ywwv3pbbxdg7v37s8vplgsz8ag016xqf5ykqqf";
  };

  patches = [ add-apocrypha add-install-target ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with stdenv.lib; {
    description = "The Bible, King James Version";
    homepage = "https://github.com/bontibon/kjv";
    license = licenses.publicDomain;
    maintainers = [ maintainers.jtobin ];
  };
}

