# Generated using generateFetchSchema.sh
fetchFromGitHub: ''
  mkdir -p package/rime
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-array";
      rev = "b37aad383ff6e71e457aa6d1d47d2040af8649b9";
      hash = "sha256-nogkrsNm+FY5SaLuQ0M6c33TqG2SLRM5TySXkaXtO08=";
    }
  } package/rime/array
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-bopomofo";
      rev = "c7618f4f5728e1634417e9d02ea50d82b71956ab";
      hash = "sha256-BoX0ueVymXaMt4nAKQz9hRrP8AQrAmUxXhbzLMG25zw=";
    }
  } package/rime/bopomofo
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-cangjie";
      rev = "8dfad9e537f18821b71ba28773315d9c670ae245";
      hash = "sha256-fmWGgYqWndCpDUV6nzx0zjkcf5AcVeDIYwp0023iMwk=";
    }
  } package/rime/cangjie
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-cantonese";
      rev = "e3c6b17e638ac8a9aeab4d5852e5909b049c5ab3";
      hash = "sha256-uJAiSY5gmVLQzMOvDSxr+78tLgNfwBifjmb5EygxKpw=";
    }
  } package/rime/cantonese
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-combo-pinyin";
      rev = "17b66079a23a00d3214639fee2b8ae97d3e620dc";
      hash = "sha256-tirlwlf6GTfhNIVrvg32gLsv1pLaN/XdVT47rmAS/cc=";
    }
  } package/rime/combo-pinyin
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-double-pinyin";
      rev = "69bf85d4dfe8bac139c36abbd68d530b8b6622ea";
      hash = "sha256-UyVzp0TMq7yq5pXQpy7xkPnc1+RF8oVdIXzvrYqLfCQ=";
    }
  } package/rime/double-pinyin
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-emoji";
      rev = "a18b09997e7c457066e4c92adf249a4b3e235f9c";
      hash = "sha256-Zp0kkp0dWZHlvitYMsV/mLPnfSzodkxlGUGH7kdOSj0=";
    }
  } package/rime/emoji
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-essay";
      rev = "e0519d0579722a0871efb68189272cba61a7350b";
      hash = "sha256-/GLyb3pVm5YzhuBWWJs75JtKZVnFXFN3s7HT+TZC4bw=";
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
      rev = "50100769f645bf92afef5170e3bf42be5147b41b";
      hash = "sha256-AD81+UJhC08nGIvDwf02Zm/N7JeQg6XiSHp1vLQWvLY=";
    }
  } package/rime/jyutping
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-luna-pinyin";
      rev = "79aeae200a7370720be98232844c0715f277e1c0";
      hash = "sha256-+pqjpYfXTdou8EofFsjUyArOs+CjJchwXbMVhGFxbhs=";
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
      rev = "52b9c75f085479799553f2499c4f4c611d618cdf";
      hash = "sha256-crUFBV/u2vwC1kj2FF6lsJdIF28wIagKHpksGR/2Kf4=";
    }
  } package/rime/pinyin-simp
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-prelude";
      rev = "dd84abecc33f0b05469f1d744e32d2b60b3529e3";
      hash = "sha256-r3jx/iCUOxBFLYhmHEuSFxzmHg8l6vnuONmsjbtBlpM=";
    }
  } package/rime/prelude
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-quick";
      rev = "3fe5911ba608cb2df1b6301b76ad1573bd482a76";
      hash = "sha256-yctopPkng3QQLhDRuHP5gpEmTx0UCO5pKXzjUv1BcCE=";
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
      rev = "f3e9189d5ce33c55d3936cc58e39d0c88b3f0c88";
      hash = "sha256-rXgWXNLEKkQWPVgcSl4LM0jJWfv8SzsPUn3ATE+/hjY=";
    }
  } package/rime/stenotype
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-stroke";
      rev = "e6c7608925009636577ff7469eecc870f1de18f3";
      hash = "sha256-D20ul7R3rPS0kQR3wsSbJi//ViRV1vSNlkkn4PSk7Oc=";
    }
  } package/rime/stroke
  ln -sv ${
    fetchFromGitHub {
      owner = "rime";
      repo = "rime-terra-pinyin";
      rev = "9427853de91d645d9aca9ceace8fe9e9d8bc5b50";
      hash = "sha256-93Kzph4q8LCNYTMk3rjO7mXwzfyF4cHnuDAQrxWOPDg=";
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
      rev = "abd1ee98efbf170258fcf43875c21a4259e00b61";
      hash = "sha256-mNqUJ9iXSDCHqvnBoJ0TxXJjS0aAtx4NCN5SxkYjxWI=";
    }
  } package/rime/wugniu
''
