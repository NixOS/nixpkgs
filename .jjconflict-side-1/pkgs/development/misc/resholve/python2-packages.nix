# Python 2 overlay applied to resholve's local python27 package set.
# Provides the bootstrap toolchain (bootstrapped-pip/pip/setuptools/wheel)
# plus resholve's own python2 build dependencies, kept here so all of
# resholve's python2 surface lives in one place.

self: super:

with self;
with super;
{
  bootstrapped-pip = toPythonModule (callPackage ./python2-modules/bootstrapped-pip { });

  pip = callPackage ./python2-modules/pip { };

  setuptools = callPackage ./python2-modules/setuptools { };

  wheel = callPackage ./python2-modules/wheel { };

  # resholve build deps
  configargparse = callPackage ./python2-modules/configargparse { };

  six = callPackage ./python2-modules/six { };

  typing = callPackage ./python2-modules/typing { };

  oildev = callPackage ./python2-modules/oildev { };

  sedparse = callPackage ./python2-modules/sedparse { };
}
