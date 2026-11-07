// We override isatty to help 'automate' installers. 

// Some installers (mojoinstall) have a stdio GUI that refuses to run if you
// feed it a file on stdin. This should help that. 

int isatty(int fd) { return 1; }
