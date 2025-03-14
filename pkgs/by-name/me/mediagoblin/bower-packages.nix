{ fetchbower, buildEnv }:
buildEnv {
  name = "bower-env";
  ignoreCollisions = true;
  paths = [
    (fetchbower "jquery" "2.1.4" "~2.1.3" "1ywrpk2xsr6ghkm3j9gfnl9r3jn6xarfamp99b0bcm57kq9fm2k0")
    (fetchbower "video.js" "5.20.5" "~5.20.1" "1agvvid2valba7xxypknbb3k578jz8sa4rsmq5z2yc5010k3nkqp")
    (fetchbower "videojs-resolution-switcher" "0.4.2" "~0.4.2"
      "1bz2q1wwdglaxbb20fin9djgs1c71jywxhlrm16hm4bzg708ycaf"
    )
    (fetchbower "leaflet" "0.7.7" "~0.7.3" "0jim285bljmxxngpm3yx6bnnd10n2whwkgmmhzpcd1rdksnr5nca")
  ];
}
