========================================================================
purescm
========================================================================


Suggested additional ``buildInputs``
====================================

``chez-racket``
   Upstream is using the Racket fork of Chez Scheme to execute the
   generated Scheme output.


To update this package
======================

#. Bump the ``./manifests/package.json`` version pin
#. Run ``(cd manifests && nix-shell -p nodejs --command "npm i --package-lock-only")``
#. Update ``npmDeps.hash`` in the ``package.nix``
