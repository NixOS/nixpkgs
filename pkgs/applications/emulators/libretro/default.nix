{
  lib,
  newScope,
}:

lib.makeScope newScope (self: {
  mkLibretroCore = self.callPackage ./mkLibretroCore.nix { };

  atari800 = self.callPackage ./cores/atari800.nix { };

  beetle-gba = self.callPackage ./cores/beetle-gba.nix { };

  beetle-lynx = self.callPackage ./cores/beetle-lynx.nix { };

  beetle-ngp = self.callPackage ./cores/beetle-ngp.nix { };

  beetle-pce = self.callPackage ./cores/beetle-pce.nix { };

  beetle-pce-fast = self.callPackage ./cores/beetle-pce-fast.nix { };

  beetle-pcfx = self.callPackage ./cores/beetle-pcfx.nix { };

  beetle-psx = self.callPackage ./cores/beetle-psx.nix { };

  beetle-psx-hw = self.beetle-psx.override { withHw = true; };

  beetle-saturn = self.callPackage ./cores/beetle-saturn.nix { };

  beetle-supafaust = self.callPackage ./cores/beetle-supafaust.nix { };

  beetle-supergrafx = self.callPackage ./cores/beetle-supergrafx.nix { };

  beetle-vb = self.callPackage ./cores/beetle-vb.nix { };

  beetle-wswan = self.callPackage ./cores/beetle-wswan.nix { };

  blastem = self.callPackage ./cores/blastem.nix { };

  bluemsx = self.callPackage ./cores/bluemsx.nix { };

  bsnes = self.callPackage ./cores/bsnes.nix { };

  bsnes-hd = self.callPackage ./cores/bsnes-hd.nix { };

  bsnes-mercury = self.callPackage ./cores/bsnes-mercury.nix { };

  bsnes-mercury-balanced = self.bsnes-mercury.override { withProfile = "balanced"; };

  bsnes-mercury-performance = self.bsnes-mercury.override { withProfile = "performance"; };

  citra = self.callPackage ./cores/citra.nix { };

  desmume = self.callPackage ./cores/desmume.nix { };

  desmume2015 = self.callPackage ./cores/desmume2015.nix { };

  dolphin = self.callPackage ./cores/dolphin.nix { };

  dosbox = self.callPackage ./cores/dosbox.nix { };

  dosbox-pure = self.callPackage ./cores/dosbox-pure.nix { };

  easyrpg = self.callPackage ./cores/easyrpg.nix { };

  eightyone = self.callPackage ./cores/eightyone.nix { };

  fbalpha2012 = self.callPackage ./cores/fbalpha2012.nix { };

  fbneo = self.callPackage ./cores/fbneo.nix { };

  fceumm = self.callPackage ./cores/fceumm.nix { };

  flycast = self.callPackage ./cores/flycast.nix { };

  fmsx = self.callPackage ./cores/fmsx.nix { };

  freeintv = self.callPackage ./cores/freeintv.nix { };

  fuse = self.callPackage ./cores/fuse.nix { };

  gambatte = self.callPackage ./cores/gambatte.nix { };

  genesis-plus-gx = self.callPackage ./cores/genesis-plus-gx.nix { };

  gpsp = self.callPackage ./cores/gpsp.nix { };

  gw = self.callPackage ./cores/gw.nix { };

  handy = self.callPackage ./cores/handy.nix { };

  hatari = self.callPackage ./cores/hatari.nix { };

  mame = self.callPackage ./cores/mame.nix { };

  mame2000 = self.callPackage ./cores/mame2000.nix { };

  mame2003 = self.callPackage ./cores/mame2003.nix { };

  mame2003-plus = self.callPackage ./cores/mame2003-plus.nix { };

  mame2010 = self.callPackage ./cores/mame2010.nix { };

  mame2015 = self.callPackage ./cores/mame2015.nix { };

  mame2016 = self.callPackage ./cores/mame2016.nix { };

  melonds = self.callPackage ./cores/melonds.nix { };

  mesen = self.callPackage ./cores/mesen.nix { };

  mesen-s = self.callPackage ./cores/mesen-s.nix { };

  meteor = self.callPackage ./cores/meteor.nix { };

  mgba = self.callPackage ./cores/mgba.nix { };

  mrboom = self.callPackage ./cores/mrboom.nix { };

  mupen64plus = self.callPackage ./cores/mupen64plus.nix { };

  neocd = self.callPackage ./cores/neocd.nix { };

  nestopia = self.callPackage ./cores/nestopia.nix { };

  np2kai = self.callPackage ./cores/np2kai.nix { };

  nxengine = self.callPackage ./cores/nxengine.nix { };

  o2em = self.callPackage ./cores/o2em.nix { };

  opera = self.callPackage ./cores/opera.nix { };

  parallel-n64 = self.callPackage ./cores/parallel-n64.nix { };

  pcsx2 = self.callPackage ./cores/pcsx2.nix { };

  pcsx-rearmed = self.callPackage ./cores/pcsx-rearmed.nix { };
  pcsx_rearmed = lib.lowPrio (self.pcsx-rearmed); # added 2024-11-20

  picodrive = self.callPackage ./cores/picodrive.nix { };

  play = self.callPackage ./cores/play.nix { };

  ppsspp = self.callPackage ./cores/ppsspp.nix { };

  prboom = self.callPackage ./cores/prboom.nix { };

  prosystem = self.callPackage ./cores/prosystem.nix { };

  puae = self.callPackage ./cores/puae.nix { };

  quicknes = self.callPackage ./cores/quicknes.nix { };

  same_cdi = self.callPackage ./cores/same_cdi.nix { }; # the name is not a typo

  sameboy = self.callPackage ./cores/sameboy.nix { };

  scummvm = self.callPackage ./cores/scummvm.nix { };

  smsplus-gx = self.callPackage ./cores/smsplus-gx.nix { };

  snes9x = self.callPackage ./cores/snes9x.nix { };

  snes9x2002 = self.callPackage ./cores/snes9x2002.nix { };

  snes9x2005 = self.callPackage ./cores/snes9x2005.nix { };

  snes9x2005-plus = self.snes9x2005.override { withBlarggAPU = true; };

  snes9x2010 = self.callPackage ./cores/snes9x2010.nix { };

  stella = self.callPackage ./cores/stella.nix { };

  stella2014 = self.callPackage ./cores/stella2014.nix { };

  swanstation = self.callPackage ./cores/swanstation.nix { };

  tgbdual = self.callPackage ./cores/tgbdual.nix { };

  thepowdertoy = self.callPackage ./cores/thepowdertoy.nix { };

  tic80 = self.callPackage ./cores/tic80.nix { };

  twenty-fortyeight = self.callPackage ./cores/twenty-fortyeight.nix { };

  vba-m = self.callPackage ./cores/vba-m.nix { };

  vba-next = self.callPackage ./cores/vba-next.nix { };

  vecx = self.callPackage ./cores/vecx.nix { };

  vice-x64 = self.callPackage ./cores/vice.nix { type = "x64"; };

  vice-x128 = self.callPackage ./cores/vice.nix { type = "x128"; };

  vice-x64dtv = self.callPackage ./cores/vice.nix { type = "x64dtv"; };

  vice-x64sc = self.callPackage ./cores/vice.nix { type = "x64sc"; };

  vice-xcbm2 = self.callPackage ./cores/vice.nix { type = "xcbm2"; };

  vice-xcbm5x0 = self.callPackage ./cores/vice.nix { type = "xcbm5x0"; };

  vice-xpet = self.callPackage ./cores/vice.nix { type = "xpet"; };

  vice-xplus4 = self.callPackage ./cores/vice.nix { type = "xplus4"; };

  vice-xscpu64 = self.callPackage ./cores/vice.nix { type = "xscpu64"; };

  vice-xvic = self.callPackage ./cores/vice.nix { type = "xvic"; };

  virtualjaguar = self.callPackage ./cores/virtualjaguar.nix { };

  yabause = self.callPackage ./cores/yabause.nix { };
})
