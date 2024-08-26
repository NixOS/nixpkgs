# Minimal {#sec-profile-minimal}

This profile defines a small NixOS configuration. It does not contain any
graphical stuff. It's a very short file that enables
[noXlibs](#opt-environment.noXlibs), sets
[](#opt-i18n.supportedLocales) to
only support the user-selected locale,
[disables packages' documentation](#opt-documentation.enable),
and [disables sound](#opt-sound.enable).

With this profile enabled, a lot of package derivations will differ from the
ones available for download in the binary cache (because the derivations in
the binary cache are built with X libraries enabled by default, while the
minimal profile disables these libraries through the `noXlibs` option), and
will thus have to be built locally. Hence, while configurations built using
this profile may be appropriate for machines with low resources, the
configurations themselves should still be built on more powerful machines.
