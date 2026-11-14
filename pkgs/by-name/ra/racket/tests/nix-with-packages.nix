{ racket }:

racket.withPackages.override { strictSetup = true; } (ps: with ps; [ racket-test ])
