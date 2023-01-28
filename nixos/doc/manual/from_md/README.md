This directory is temporarily needed while we transition the manual to CommonMark. It stores the output of the ../md-to-db.sh script that converts CommonMark files back to DocBook.

We are choosing to convert the Markdown to DocBook at authoring time instead of manual building time, because we do not want the pandoc toolchain to become part of the NixOS closure.

Do not edit the DocBook files inside this directory or its subdirectories. Instead, edit the corresponding .md file in the normal manual directories, and run ../md-to-db.sh to update the file here.
