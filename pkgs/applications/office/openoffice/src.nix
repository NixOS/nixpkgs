fetchurl:
[
  (fetchurl {
    url = "http://download.go-oo.org//DEV300/ooo-cli-prebuilt-3.2.tar.bz2";
    sha256 = "1v55fl0n8zisn6gih99fn1c5vp6wl6cf0qh1nwlcx9ia76jnjj9k";
  })
/*
  (fetchurl {
    url = "http://cairographics.org/releases//cairo-1.4.10.tar.gz";
    sha256 = "0cji7shlnd3yg3939233p8imnrivykx4g39p3qr8r2a4c2k7hkjr";
  })
*/
  (fetchurl {
    url = "http://download.go-oo.org//SRC680/mdbtools-0.6pre1.tar.gz";
    sha256 = "1lz33lmqifjszad7rl1r7rpxbziprrm5rkb27wmswyl5v98dqsbi";
  })
  (fetchurl {
    url = "http://cgit.freedesktop.org/ooo-build/artwork/snapshot/ooo/OOO320_m12.tar.bz2";
    name = "ooo320-m12-artwork.tar.bz2";
    sha256 = "1zfn1gjdbxychxb9xvfi9hchzqbp20f15nf06badgga5klllir8b";
  })
  (fetchurl {
    url = "http://cgit.freedesktop.org/ooo-build/base/snapshot/ooo/OOO320_m12.tar.bz2";
    name = "ooo320-m12-base.tar.bz2";
    sha256 = "07gmicn9c2x16qzcfi0jh2z8mx0iz76vhskml7xkwv99vryy48im";
  })
  (fetchurl {
    url = "http://cgit.freedesktop.org/ooo-build/bootstrap/snapshot/ooo/OOO320_m12.tar.bz2";
    name = "ooo320-m12-bootstrap.tar.bz2";
    sha256 = "070zmd25wysmf2rka07b8w02wkyxz7qa30kscd9b3pc8m0cgq0fl";
  })
  (fetchurl {
    url = "http://cgit.freedesktop.org/ooo-build/calc/snapshot/ooo/OOO320_m12.tar.bz2";
    name = "ooo320-m12-calc.tar.bz2";
    sha256 = "0iwgmvffljmm1vbkjv36fq0riy7alk7r4gnfl5x9nrw7zic0xh29";
  })
  (fetchurl {
    url = "http://cgit.freedesktop.org/ooo-build/components/snapshot/ooo/OOO320_m12.tar.bz2";
    name = "ooo320-m12-components.tar.bz2";
    sha256 = "19x6lhdbcazkicp4h3zs8sq7n9gc7z9c3xkx6266m15n2k4c8ms9";
  })
  (fetchurl {
    url = "http://cgit.freedesktop.org/ooo-build/extras/snapshot/ooo/OOO320_m12.tar.bz2";
    name = "ooo320-m12-extras.tar.bz2";
    sha256 = "1lr8l0nxaqrhgcbb1vn08a8d4wzq032q2zl9a12dgjrnmgcx76s7";
  })
  (fetchurl {
    url = "http://cgit.freedesktop.org/ooo-build/filters/snapshot/ooo/OOO320_m12.tar.bz2";
    name = "ooo320-m12-filters.tar.bz2";
    sha256 = "1p13w9gngc5wz40nhsx8igk8zygnwcacd3bgas3m2jv9ifazk9v3";
  })
  (fetchurl {
    url = "http://cgit.freedesktop.org/ooo-build/help/snapshot/ooo/OOO320_m12.tar.bz2";
    name = "ooo320-m12-help.tar.bz2";
    sha256 = "0fqg8fpivgpyfqf0s085mjm09cmfzy684q1b58y62hg0f01wwr0k";
  })
  (fetchurl {
    url = "http://cgit.freedesktop.org/ooo-build/impress/snapshot/ooo/OOO320_m12.tar.bz2";
    name = "ooo320-m12-impress.tar.bz2";
    sha256 = "1dhrdsak1jqydjfkylj6r7w1h886gbcn1g4wjh1kgkwk50bdamh5";
  })
  (fetchurl {
    url = "http://cgit.freedesktop.org/ooo-build/libs-gui/snapshot/ooo/OOO320_m12.tar.bz2";
    name = "ooo320-m12-libs-gui.tar.bz2";
    sha256 = "0x5jf8bwzqkd76dpd7rh0fj1p4hmh8h9yshn8rfq6ss26bgwnmwr";
  })
  (fetchurl {
    url = "http://cgit.freedesktop.org/ooo-build/libs-core/snapshot/ooo/OOO320_m12.tar.bz2";
    name = "ooo320-m12-libs-core.tar.bz2";
    sha256 = "1qaa1g9mrlpjv7fkv0c8qarbl162l99w0a92ydsj1lv86jg01xvx";
  })
  (fetchurl {
    url = "http://cgit.freedesktop.org/ooo-build/libs-extern/snapshot/ooo/OOO320_m12.tar.bz2";
    name = "ooo320-m12-libs-extern.tar.bz2";
    sha256 = "0hxkba5yb1c09yyrqpw4llrr7xhpf5x08mnwgfdcfks690p1rzc9";
  })
  (fetchurl {
    url = "http://cgit.freedesktop.org/ooo-build/postprocess/snapshot/ooo/OOO320_m12.tar.bz2";
    name = "ooo320-m12-postprocess.tar.bz2";
    sha256 = "1jkkxpc199y64a41y13s6ib6gyp6gas8gl4w95sx506xvj90qxi3";
  })
  (fetchurl {
    url = "http://cgit.freedesktop.org/ooo-build/sdk/snapshot/ooo/OOO320_m12.tar.bz2";
    name = "ooo320-m12-sdk.tar.bz2";
    sha256 = "0211ak14sblmzswwa605q430gxxdjrqa5a2924r4lb1knrc9vlns";
  })
  (fetchurl {
    url = "http://cgit.freedesktop.org/ooo-build/testing/snapshot/ooo/OOO320_m12.tar.bz2";
    name = "ooo320-m12-testing.tar.bz2";
    sha256 = "0i7bcxd791id2bbgnsakwnmr4xnzd5hdcydlnqx50mni5mcd13v1";
  })
  (fetchurl {
    url = "http://cgit.freedesktop.org/ooo-build/ure/snapshot/ooo/OOO320_m12.tar.bz2";
    name = "ooo320-m12-ure.tar.bz2";
    sha256 = "16957l2npcbaizs29ly0xxfqaxinchnrvi720gggwhfp2mbl05ql";
  })
  (fetchurl {
    url = "http://cgit.freedesktop.org/ooo-build/writer/snapshot/ooo/OOO320_m12.tar.bz2";
    name = "ooo320-m12-writer.tar.bz2";
    sha256 = "0lcdlwy2scs01glj8fi1q1ysmyvn7j70b91ciad3m32lrxmr8s67";
  })
  (fetchurl {
    url = "http://cgit.freedesktop.org/ooo-build/libs-extern-sys/snapshot/ooo/OOO320_m12.tar.bz2";
    name = "ooo320-m12-libs-extern-sys.tar.bz2";
    sha256 = "0my3wh90xil3xpcjxi1q76v1bwi0rf62pzrf3pi3angd5y3hmysd";
  })
  (fetchurl {
    url = "http://cgit.freedesktop.org/ooo-build/extensions/snapshot/ooo/OOO320_m12.tar.bz2";
    name = "ooo320-m12-extensions.tar.bz2";
    sha256 = "1qmyc2vb0n6fdl7p92cpvp972zm6ilafq5s5m21wgicqwfr34chv";
  })
  (fetchurl {
    url = "http://download.go-oo.org//SRC680/extras-3.tar.bz2";
    sha256 = "1s6cz92b2amfn135l6a2hras4qrd04kw5yyqli7xmb8xqa0m3y3c";
  })
  (fetchurl {
    url = "http://download.go-oo.org//SRC680/biblio.tar.bz2";
    sha256 = "02v2xbq771zi09qw3k4zih95m1rjns4pwwpl51n0m34c0a00lhf0";
  })
  (fetchurl {
    url = "http://tools.openoffice.org/unowinreg_prebuild/680//unowinreg.dll";
    sha256 = "0g3529nr0nfhn3cygn8x931pqxnqq88nfc5h829xncr1j8ifaqzm";
  })
  (fetchurl {
    url = "http://cgit.freedesktop.org/ooo-build/l10n/snapshot/ooo/OOO320_m12.tar.bz2";
    name = "ooo320-m12-l10n.tar.bz2";
    sha256 = "0lknxxl0n4f383gxkljl1294zggfgaf2hbg3f6p4q6vr1byf3lww";
  })
  (fetchurl {
    url = "http://download.go-oo.org//SRC680/libwps-0.1.2.tar.gz";
    sha256 = "1cdjmgpy0igrwlb5i1sm4s2yxvzbmqz6j7xnmmv3kpbx7z43zw78";
  })
  (fetchurl {
    url = "http://download.go-oo.org//SRC680/libwpg-0.1.3.tar.gz";
    sha256 = "1qv5qqycaqrm8arprwf3vyk76fm6v7qabpx5qq58knp1xm72z98r";
  })
  (fetchurl {
    url = "http://download.go-oo.org//DEV300/ooo_oxygen_images-2009-06-17.tar.gz";
    sha256 = "0jhgjhm63cmjr59nhvdln1szgm36v6kkazy2388l7z6xjjrhxk1z";
  })
]
