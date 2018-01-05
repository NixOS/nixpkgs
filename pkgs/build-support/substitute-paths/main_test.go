package main

import (
	"testing"
)

var testTable = map[string]string{
	"a":   "/bin/a",
	"xa":  "/bin/xa",
	"ax":  "/bin/ax",
	"a.b": "a.b",
}

func TestReplace(t *testing.T) {
	source := `
#! /usr/bin/env a
/bin/a bin/a
/usr/bin/xa /var/usr/bin/xa
/bin/env ax
/bin/a-b /bin/a.b
`
	expected := `
#! /bin/a
/bin/a bin/a
/bin/xa /var/bin/xa
/bin/ax
/bin/a-b a.b
`
	replace := makeReplacer(BinPattern, testTable)
	actual := string(replace([]byte(source)))
	if expected != actual {
		t.Errorf("\nEXPECTED%s\nACTUAL%s", expected, actual)
		t.FailNow()
	}
}
