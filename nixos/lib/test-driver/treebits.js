$(document).ready(function() {

    /* When a toggle is clicked, show or hide the subtree. */
    $(".logTreeToggle").click(function() {
        if ($(this).siblings("ul:hidden").length != 0) {
            $(this).siblings("ul").show();
            $(this).text("-");
        } else {
            $(this).siblings("ul").hide();
            $(this).text("+");
        }
    });

    /* Implementation of the expand all link. */
    $(".logTreeExpandAll").click(function() {
        $(".logTreeToggle", $(this).parent().siblings(".toplevel")).map(function() {
            $(this).siblings("ul").show();
            $(this).text("-");
        });
    });

    /* Implementation of the collapse all link. */
    $(".logTreeCollapseAll").click(function() {
        $(".logTreeToggle", $(this).parent().siblings(".toplevel")).map(function() {
            $(this).siblings("ul").hide();
            $(this).text("+");
        });
    });

});
