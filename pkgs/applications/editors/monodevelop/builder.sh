. $stdenv/setup

export PERL5LIB=$perlXMLParser/lib/site_perl:$PERL5LIB

export MONO_GAC_PREFIX=$monodoc:$gtksharp

genericBuild

