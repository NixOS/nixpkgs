window.onload = function() {
    surround = document.createElement("div");
    surround.innerHTML = `
    <div id='searchstatus'>LOADING...</div>
    <form>
      <input type='search' onkeyup='dosort(this.value);' />
    </form>
    <h2>search results for <tt id='searchterm'>(nothing)</tt></h2>
    <div id='searchresult'></div>
    <div class='navheader'>`;
    document.getElementsByTagName("body")[0].prepend(surround);

fetch("index.json")
    .then(response => response.json())
    .then(v => window.index = elasticlunr.Index.load(v))
    .then(v => document.getElementById("searchstatus").innerText = "Ready!")
/*index = elasticlunr.Index.load(window.v)*/

}

function removeChildren(elem) {
    while (elem.firstChild) {
        elem.removeChild(elem.firstChild);
    }
}

function dosort(term) {
    searchresults = document.getElementById("searchresult")
    searchterm = document.getElementById("searchterm")
    result = window.index.search(term);
    removeChildren(searchresults);
    for(var i = 0; i < result.length ; i++){
        var resultElem = document.createElement('li');
        resultElem.innerHTML = '<a href="' + result[i].ref + '">' + result[i].doc.title + '</a>';
        searchresults.appendChild(resultElem);
    }
    searchterm.innerText = term;
}
