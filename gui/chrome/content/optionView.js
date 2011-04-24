// extend NixOS options to handle the Tree View.  Should be better to keep a
// separation of concern here.

Option.prototype.tv_opened = false;
Option.prototype.tv_size = 1;

Option.prototype.tv_open = function () {
  this.tv_opened = true;
  this.tv_size = 1;

  // load an option if it is not loaded yet, and initialize them to be
  // read by the Option view.
  if (!this.isLoaded)
    this.load();

  // If this is not an option, then add it's lits of sub-options size.
  if (!this.isOption)
  {
    for (var i = 0; i < this.subOptions.length; i++)
      this.tv_size += this.subOptions[i].tv_size;
  }
};

Option.prototype.tv_close = function () {
  this.tv_opened = false;
  this.tv_size = 1;
};




function OptionView (root, selCallback) {
  root.tv_open();
  this.rootOption = root;
  this.selCallback = selCallback;
}

OptionView.prototype = {
  rootOption: null,
  selCallback: null,

  // This function returns the path to option which is at the specified row.
  reach_cache: null,
  reachRow: function (row) {
    var o = this.rootOption; // Current option.
    var r = 0; // Number of rows traversed.
    var c = 0; // Child index.
    var path = [{ row: r, opt: o }]; // new Array();
    // hypothesis: this.rootOption.tv_size is always open and bigger than

    // Use the previous returned value to avoid making to many checks and to
    // optimize for frequent access of near rows.
    if (this.reach_cache != null)
    {
      for (var i = this.reach_cache.length - 2; i >= 0; i--) {
        var p = this.reach_cache[i];
        // If we will have to go the same path.
        if (row >= p.row && row < p.row + p.opt.tv_size)
        {
          path.unshift(p);
          r = path[0].row;
          o = path[0].opt;
        }
        else
          break;
      };
    }

    while (r != row)
    {
      // Go deeper in the child which contains the requested row.  The
      // tv_size contains the size of the tree starting from each option.
      c = 0;
      while (c < o.subOptions.length && r + o.subOptions[c].tv_size < row)
      {
        r += o.subOptions[c].tv_size;
        c += 1;
      }
      if (c < o.subOptions.length && r + o.subOptions[c].tv_size >= row)
      {
        // Count the current option as a row.
        o = o.subOptions[c];
        r += 1;
      }
      else
        alert("WTF: " + o.name + " ask: " + row + " children: " + o.subOptions + " c: " + c);
      path.unshift({ row: r, opt: o });
    }

    this.reach_cache = path;
    return path;
  },

  // needs to return true if there is a /row/ at the same level /after/ a
  // given row.
  hasNextSibling: function(row, after) {
    log("sibling " + row + " after " + after);
    var path = reachRow(row);
    if (path.length > 1)
    {
      var last = path[1].row + path[1].opt.tv_size;
      // Has a next sibling if the row is not over the size of the
      // parent and if the current one is not the last child.
      return after + 1 < last && path[0].row + path[0].opt.tv_size < last;
    }
    else
      // The top-level option has no sibling.
      return false;
  },

  // Does the current row contain any sub-options?
  isContainer: function(row) {
    return !this.reachRow(row)[0].opt.isOption;
  },
  isContainerEmpty: function(row) {
    return this.reachRow(row)[0].opt.subOptions.length == 0;
  },
  isContainerOpen: function(row) {
    return this.reachRow(row)[0].opt.tv_opened;
  },

  // Open or close an option.
  toggleOpenState: function (row) {
    var path = this.reachRow(row);
    var delta = -path[0].opt.tv_size;
    if (path[0].opt.tv_opened)
      path[0].opt.tv_close();
    else
      path[0].opt.tv_open();
    delta += path[0].opt.tv_size;

    // Parents are alreay opened, but we need to update the tv_size
    // counters.  Thus we have to invalidate the reach cache.
    this.reach_cache = null;
    for (var i = 1; i < path.length; i++)
      path[i].opt.tv_open();

    this.tree.rowCountChanged(row + 1, delta);
  },

  // Return the identation level of the option at the line /row/.  The
  // top-level level is 0.
  getLevel: function(row) {
    return this.reachRow(row).length - 1;
  },

  // Obtain the index of a parent row. If there is no parent row,
  // returns -1.
  getParentIndex: function(row) {
    var path = this.reachRow(row);
    if (path.length > 1)
      return path[1].row;
    else
      return -1;
  },


  // Return the content of each row base on the column name.
  getCellText: function(row, column) {
    if (column.id == "opt-name")
      return this.reachRow(row)[0].opt.name;
    if (column.id == "dbg-size")
      return this.reachRow(row)[0].opt.tv_size;
    return "";
  },

  // We have no column with images.
  getCellValue: function(row, column) { },


  isSelectable: function(row, column) { return true; },

  // Get the selection out of the tree and give options to the call back
  // function.
  selectionChanged: function() {
    if (this.selCallback == null)
      return;
    var opts = [];
    var start = new Object();
    var end = new Object();
    var numRanges = this.tree.view.selection.getRangeCount();

    for (var t = 0; t < numRanges; t++) {
      this.tree.view.selection.getRangeAt(t,start,end);
      for (var v = start.value; v <= end.value; v++) {
        var opt = this.reachRow(v)[0].opt;
        if (!opt.isLoaded)
          opt.load();
        if (opt.isOption)
          opts.push(opt);

        // FIXME: no need to make things slowing down, because our current
        // callback do not handle multiple option display.
        if (!opts.empty)
          break;
      }
      // FIXME: no need to make things slowing down, because our current
      // callback do not handle multiple option display.
      if (!opts.empty)
        break;
    }

    if (!opts.empty)
      this.selCallback(opts);
  },

  set rowCount(c) { throw "rowCount is a readonly property"; },
  get rowCount() { return this.rootOption.tv_size; },

  // refuse drag-n-drop of options.
  canDrop: function (index, orientation, dataTransfer) { return false; },
  drop: function (index, orientation, dataTransfer) { },

  // ?
  getCellProperties: function(row, column, prop) { },
  getColumnProperties: function(column, prop) { },
  getRowProperties: function(row, prop) { },
  getImageSrc: function(row, column) { },

  // No progress columns are used.
  getProgressMode: function(row, column) { },

  // Do not add options yet.
  isEditable: function(row, column) { return false; },
  setCellValue: function(row, column, value) { },
  setCellText: function(row, column, value) { },

  // ...
  isSeparator: function(index) { return false; },
  isSorted: function() { return false; },
  performAction: function(action) { },
  performActionOnCell: function(action, row, column) { },
  performActionOnRow: function(action, row) { }, // ??

  // ??
  cycleCell: function (row, col) { },
  cycleHeader: function(col) { },

  selection: null,
  tree: null,
  setTree: function(tree) { this.tree = tree; }
};
