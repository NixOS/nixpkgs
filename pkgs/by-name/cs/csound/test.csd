<CsoundSynthesizer>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

instr 1
  iengine fluidEngine
  aleft, aright fluidOut iengine
  atone STKBeeThree 440, 0.2
  out aleft + atone, aright + atone
endin
</CsInstruments>
<CsScore>
i 1 0 0.1
e
</CsScore>
</CsoundSynthesizer>
