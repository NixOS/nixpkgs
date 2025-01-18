{
  lib,
  fetchFromGitHub,
  fetchpatch,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "dstat";
  format = "other";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "dstat-real";
    repo = "dstat";
    rev = "v${version}";
    sha256 = "1qnmkhqmjd1m3if05jj29dvr5hn6kayq9bkkkh881w472c0zhp8v";
  };

  propagatedBuildInputs = with python3Packages; [ six ];

  patches = [
    ./fix_pluginpath.patch
    # this fixes another bug with python3
    (fetchpatch {
      url = "https://github.com/efexgee/dstat/commit/220a785321b13b6df92a536080aca6ef1cb644ad.patch";
      sha256 = "08kcz3yxvl35m55y7g1pr73x3bjcqnv0qlswxqyq8cqxg9zd64cn";
    })
  ];

  makeFlags = [ "prefix=$(out)" ];

  # remove deprecation warnings
  preFixup = ''
    sed -i "s/import collections/import collections.abc/g" $out/share/dstat/dstat.py $out/bin/dstat
    sed -i "s/collections.Sequence/collections.abc.Sequence/g" "$out"/bin/dstat
  '';

  meta = with lib; {
    homepage = "http://dag.wieers.com/home-made/dstat/";
    description = "Versatile resource statistics tool";
    mainProgram = "dstat";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ ];
    changelog = "https://github.com/dstat-real/dstat/blob/v${version}/ChangeLog";
  };
}
