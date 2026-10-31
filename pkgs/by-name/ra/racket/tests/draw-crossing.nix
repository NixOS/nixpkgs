{ runCommandLocal, racket }:

runCommandLocal "racket-test-draw-crossing"
  {
    nativeBuildInputs = [ racket ];
  }
  ''
    racket -f - <<EOF
    (require racket/draw)

    (define target (make-bitmap 64 64))
    (define dc (new bitmap-dc% [bitmap target]))
    (send dc draw-line 0 0 64 64)
    (send dc draw-line 0 64 64 0)

    (send target save-file (getenv "out") 'png)
    EOF
  ''
