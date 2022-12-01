# NixOS Tests {#sec-nixos-tests}

When you add some feature to NixOS, you should write a test for it.
NixOS tests are kept in the directory `nixos/tests`, and are executed
(using Nix) by a testing framework that automatically starts one or more
virtual machines containing the NixOS system(s) required for the test.

```{=docbook}
<xi:include href="writing-nixos-tests.section.xml" />
<xi:include href="running-nixos-tests.section.xml" />
<xi:include href="running-nixos-tests-interactively.section.xml" />
<xi:include href="linking-nixos-tests-to-packages.section.xml" />
```
