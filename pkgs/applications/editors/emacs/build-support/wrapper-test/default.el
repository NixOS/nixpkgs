;;; default.el --- Similar to init.el  -*- lexical-binding: t; -*-

;;; Code:

(defvar with-packages-default-is-loaded t)

(defvar with-packages-early-default-is-loaded-before-default nil)
(setq with-packages-early-default-is-loaded-before-default
      (boundp 'with-packages-early-default-is-loaded))

(provide 'default)

;;; default.el ends here
