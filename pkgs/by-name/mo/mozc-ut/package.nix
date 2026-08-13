{
  mozc,
  mozcdic-ut-alt-cannadic,
  mozcdic-ut-edict2,
  mozcdic-ut-jawiki,
  mozcdic-ut-neologd,
  mozcdic-ut-personal-names,
  mozcdic-ut-place-names,
  mozcdic-ut-skk-jisyo,
  mozcdic-ut-sudachidict,
  withIbus ? false,
}:
mozc.override {
  inherit withIbus;
  dictionaries = [
    mozcdic-ut-alt-cannadic
    mozcdic-ut-edict2
    mozcdic-ut-jawiki
    mozcdic-ut-neologd
    mozcdic-ut-personal-names
    mozcdic-ut-place-names
    mozcdic-ut-skk-jisyo
    mozcdic-ut-sudachidict
  ];
}
