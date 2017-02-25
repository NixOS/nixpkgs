{ stdenv, fetchurl, python3Packages }:

python3Packages.buildPythonApplication rec {
  version = "0.7.2";
  name = "mwic-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/jwilk/mwic/releases/download/${version}/${name}.tar.gz";
    sha256 = "1linpagf0i0ggicq02fcvz4rpx7xdpy80ys49wx7fnmz7f3jc6jy";
  };

  meta = {
    homepage = http://jwilk.net/software/mwic;
    description = "spell-checker that groups possible misspellings and shows them in their contexts";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}

