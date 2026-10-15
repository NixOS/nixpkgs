# Generated using generateFetchSchema.sh
fetchFromGitHub: ''
  mkdir -p package/rime
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-array";
      rev = "557dbe38381de174fe96e53e9bf8c863a275307c";
      hash = "sha256-p+WoOc7lLNLGA3PCHJ0tWeW9I1JgUi6zxg7Ez637CFM=";
    }
  } package/rime/array
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-bopomofo";
      rev = "6085c9a38a4a728047862b33d67eee18aa86f3b9";
      hash = "sha256-aY+ZgSi3RRzPLdZaut72PKu96gOF0/PL308Qb1+y1d0=";
    }
  } package/rime/bopomofo
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-cangjie";
      rev = "52d90a1b1312e74042b38c1cbc8142defbc53171";
      hash = "sha256-dOwHk+nykmHCcwXZLgph7ucLmSwK3CUoBLg3zmdrqtY=";
    }
  } package/rime/cangjie
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-cantonese";
      rev = "259f0e48bba840c3a2e0d117539e96937f3d89bc";
      hash = "sha256-ctyYZQVCd9Sc7oqPmP4lO1Q0TYDQILqt/BRloaEWjPg=";
    }
  } package/rime/cantonese
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-combo-pinyin";
      rev = "25e07a1090ee2e9de59cd58a0b3b450dfa3bbc34";
      hash = "sha256-cAHjBrjtCZDWkNIr9p1Nx/Tdt7NigPsSCmvC3NbOSnY=";
    }
  } package/rime/combo-pinyin
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-double-pinyin";
      rev = "01a13287cbd27819be1c34fa1ddc1b3643d5001b";
      hash = "sha256-iHaGHKwmhyciU6zKJRLyRETRR15QSHZ7ML1l4iAV6eM=";
    }
  } package/rime/double-pinyin
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-emoji";
      rev = "39d232996de79a95d7bf4b5e8533feed5326b075";
      hash = "sha256-fS9Or4/I8c0N7GFM5JH7p/ficU8+XXUIGnu3d5i9vAI=";
    }
  } package/rime/emoji
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-essay";
      rev = "054920de4f54c9e5994276a96a4fc2a35cb51aa3";
      hash = "sha256-K98ezXSFQYxcEUZ2EzTZwdA+JljAgrsGax4Wth73F80=";
    }
  } package/rime/essay
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-ipa";
      rev = "22b71710e029bcb412e9197192a638ab11bc2abf";
      hash = "sha256-U2S+OPddG2sQmiKwWI/wxplNg8xRWVlhwUO6iZMjs30=";
    }
  } package/rime/ipa
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-jyutping";
      rev = "ee5e72b2b50a6708162a0402b91f257323bf852b";
      hash = "sha256-/9Xlto2aFihpmj6urAyqbqsC2I1Ucu5oSynNpjl99zE=";
    }
  } package/rime/jyutping
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-luna-pinyin";
      rev = "56b934b099dfbeab842320f13aa8b461a6ab3e42";
      hash = "sha256-yXkF2f980Z0OMb39QQHknqodzIj3SyW23NVo+1C2p/s=";
    }
  } package/rime/luna-pinyin
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-middle-chinese";
      rev = "582e144e525525ac2b6c2498097d7c7919e84174";
      hash = "sha256-pWtKbvP8lYJCoDI7wTkPrmUJMNuKgVxs2hAwr4cTskc=";
    }
  } package/rime/middle-chinese
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-pinyin-simp";
      rev = "0c6861ef7420ee780270ca6d993d18d4101049d0";
      hash = "sha256-eVd7dbiMH1sb/ZhZFwYxbhS4cQ2Wt2K3ZMfeTUozl9E=";
    }
  } package/rime/pinyin-simp
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-prelude";
      rev = "082425ea0684bca36474415d4a0e8db9b016487e";
      hash = "sha256-roHPpaAbsnQgnz6kupMz/kHFQWwshRYojNsdS5iFApI=";
    }
  } package/rime/prelude
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-quick";
      rev = "5dcdb9e353d314239e9c8cddc0f42d52da4837bb";
      hash = "sha256-O+Rbsff2V+TTfrC82PZftALEDDVI2SUUFBlDHyztH/k=";
    }
  } package/rime/quick
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-scj";
      rev = "cab5a0858765eff0553dd685a2d61d5536e9149c";
      hash = "sha256-cztD+cvEj2alSMyL9DOhM936uPSc1RobUiYhcuUSLSs=";
    }
  } package/rime/scj
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-soutzoe";
      rev = "beeaeca72d8e17dfd1e9af58680439e9012987dc";
      hash = "sha256-jFENhKM08x2qROqefG95gjKJtvrIFopMsB0DnTDo2Es=";
    }
  } package/rime/soutzoe
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-stenotype";
      rev = "bef930831ffe97846fa484a81014ad3e465a25c1";
      hash = "sha256-SsHhn1/Gw7KdY6jHGi+9xJA3U77mtsItk+XJptyeUbI=";
    }
  } package/rime/stenotype
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-stroke";
      rev = "1e8fff9b9494ddec23b0cbc526bcfd8171a6fd48";
      hash = "sha256-Tp0EOaM4uRkEGm9fV4o/lg7ddkj9z+FBn1PdX2o7fgQ=";
    }
  } package/rime/stroke
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-terra-pinyin";
      rev = "723e51bc266cf9464530c1ddedb856aa18e3da34";
      hash = "sha256-NS+UurPe7VglcImgsY/X+MH9g7opF7vsw8vVWKbUt3M=";
    }
  } package/rime/terra-pinyin
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-wubi";
      rev = "152a0d3f3efe40cae216d1e3b338242446848d07";
      hash = "sha256-IetRNGZkyAzZ8tqqpa45oit0nQw1qx5BdwRhQDibUdw=";
    }
  } package/rime/wubi
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-wugniu";
      rev = "2818f4812af3b6f11fc0248fa8918966a3312d2c";
      hash = "sha256-yt3d5kYusF5l8rwl0S6BMCYaSZKl4nbRpW04jO00wBs=";
    }
  } package/rime/wugniu
''
