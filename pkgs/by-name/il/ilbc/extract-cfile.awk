BEGIN { srcname = "nothing"; }
{ if (/^A\.[0-9][0-9]*\.* *[a-zA-Z][a-zA-Z_0-9]*\.[ch]/) {
    if (srcname != "nothing")
      close(srcname);
    srcname = $2;
    printf("creating source file %s\n", srcname);
  }else if (srcname != "nothing") {
    if (/Andersen,* *et* *al\./) 
      printf("skipping %s\n", $0);
    else if (//)
      printf("skipping2 %s\n", $0);
    else if (/Internet Low Bit Rate Codec *December 2004/)
      printf("skipping3 %s\n", $0);
    else if (/Authors' *Addresses/){
      close(srcname);
      exit;}
    else
      print $0 >> srcname;
  }
}
END {
  printf("ending file %s\n", srcname);
  close(srcname);
}
